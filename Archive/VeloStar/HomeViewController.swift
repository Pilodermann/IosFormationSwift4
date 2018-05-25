//
//  HomeViewController.swift
//  VeloStar
//
//  Created by Baptiste Alexandre on 22/05/2018.
//  Copyright © 2018 ALXDR. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var stationsArray: [VeloStarStation]!
    var locationManager: CLLocationManager!
    var selectedStation: VeloStarStation!
    
    let regionRadius: CLLocationDistance = 5000
    let initialLocation = CLLocation(latitude: 48.1132635, longitude: -1.682506)
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        refreshStationList()
        fetchStations()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        centerMapOnLocation(location: initialLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            mapView.isHidden = true
        } else {
            tableView.isHidden = true
            mapView.isHidden = false
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.stationsArray != nil) {
            return (self.stationsArray?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCellIdentifier", for: indexPath) as! StationTableViewCell
        
        let station = self.stationsArray[indexPath.row]
        cell.stationNameLabel.text = station.name
        cell.nbAvailableBikesLabel.text = station.nbAvailableBikes
        cell.nbAvailableSlotsLabel.text = station.nbAvailableSlots
        cell.stationDistanceLabel.text = station.distanceString
        
        if (userLocation == nil) {
            cell.stationDistanceLabel.text = ""
        }
        
        return cell
    }
    
    // MARK: - API
    
    func refreshStationList() {
        let urlString = "https://data.rennesmetropole.fr/api/records/1.0/search/?dataset=etat-des-stations-le-velo-star-en-temps-reel&rows=200&facet=nom&facet=etat&facet=nombreemplacementsactuels&facet=nombreemplacementsdisponibles&facet=nombrevelosdisponibles"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error != nil) {
                print(error?.localizedDescription ?? "unknown error")
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                
                if let records = json["records"] as? NSArray {
                    DispatchQueue.main.async {
                        self.createStationEntitiesFrom(array: records)
                    }
                }
            } catch let error as NSError {
                print(error)
            }
            
            }.resume()
        
    }
    
    private func createStationEntitiesFrom(array: NSArray) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Station", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        request.returnsObjectsAsFaults = false
        
        
        for station in array {
            if let stationDict = station as? NSDictionary {
                if let stationFields = stationDict["fields"] as? NSDictionary {
                    
                    if let stationIdentifier = stationFields["idstation"] as? Int {
                        
                        var station = stationAlreadyExists(identifier: String(stationIdentifier))
                        if (station == nil){
                            station = NSManagedObject(entity: entity!, insertInto: context) as? VeloStarStation
                            
                            station?.setValue(String(stationIdentifier), forKey: "identifier")
                        }
                        
                        if let stationName = stationFields["nom"] as? String {
                            station?.setValue(String(stationName), forKey: "name")
                        }
                        
                        if let stationIdentifier = stationFields["idstation"] as? Int {
                            station?.setValue(String(stationIdentifier), forKey: "identifier")
                        }
                        if let stationAvailableSlots = stationFields["nombreemplacementsdisponibles"] as? Int {
                            station?.setValue(String(stationAvailableSlots), forKey: "nbAvailableSlots")
                        }
                        if let stationAvailableBikes = stationFields["nombrevelosdisponibles"] as? Int {
                            station?.setValue(String(stationAvailableBikes), forKey: "nbAvailableBikes")
                        }
                        if let stationName = stationFields["etat"] as? String {
                            station?.setValue(String(stationName), forKey: "state")
                        }
                        
                        if let stationCoordinates = stationFields["coordonnees"] as? NSArray {
                            if let latitude = stationCoordinates[0] as? Double {
                                station?.setValue(String(latitude), forKey: "latitude")
                            }
                            if let longitude = stationCoordinates[1] as? Double {
                                station?.setValue(String(longitude), forKey: "longitude")
                            }
                        }
                    }
                }
            }
        }
        
        
        do {
            try context.save()
        } catch {
            print("failed saving")
        }
        
        fetchStations()
        
    }
    
    func stationAlreadyExists(identifier: String) -> VeloStarStation? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        request.predicate = NSPredicate(format: "identifier = %@", identifier)
        
        do {
            let stationList = try context.fetch(request) as! [VeloStarStation]
            
            if (stationList.count > 0) {
                return stationList.first
            }
        } catch {
            print("error")
        }
        return nil
    }
    
    private func fetchStations() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        request.returnsObjectsAsFaults = false
        
        mapView.removeAnnotations(mapView.annotations)
        
        do {
            let stationList = try context.fetch(request) as! [VeloStarStation]
            
            self.stationsArray = stationList
            
            mapView.addAnnotations(self.stationsArray)
            
        } catch {
            print("error")
            self.stationsArray = nil
        }
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedStation = self.stationsArray[indexPath.row]
        
        performSegue(withIdentifier: "showDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.selectedStation = selectedStation
            }
        }
    }
    
    // MARK: - Map
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.count > 0) {
            userLocation = locations.first
        }
        
        for station in stationsArray {
            let stationLocation = CLLocation(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude)
            
            if let dist = self.userLocation?.distance(from: stationLocation) {
                station.distance = Double(lround(dist))
            } else {
                station.distance = 0
            }
        }
        
        let sortedStations = stationsArray.sorted(by: {$0.distance < $1.distance})
        
        stationsArray = sortedStations
        
        self.tableView.reloadData()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        userLocation = nil
        print(error)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let detailVC = segue.destination as! DetailViewController {
    //            detailVC.station = selectedStation
    //        }
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
