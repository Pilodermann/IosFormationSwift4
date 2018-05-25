//
//  DetailViewController.swift
//  VeloStar
//
//  Created by Baptiste Alexandre on 24/05/2018.
//  Copyright © 2018 ALXDR. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedStation: VeloStarStation!
    var pickerController: UIImagePickerController!
    @IBOutlet weak var nbAvailableBikesLabel: UILabel!
    @IBOutlet weak var nbAvailableSlotsLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (selectedStation != nil) {
            stationNameLabel.text = selectedStation.name
            nbAvailableBikesLabel.text = selectedStation.nbAvailableBikes
            
            nbAvailableSlotsLabel.text = selectedStation.nbAvailableSlots

            configureMap()
        }
    }

    func configureMap() {
        
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        guard let selectedStation = selectedStation else { return }
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        
        let region = MKCoordinateRegion(center: selectedStation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(selectedStation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePictureButtonPressed(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Signaler une anomalie", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Appareil photo", style: .default, handler: { (alert:UIAlertAction!) in
            self.showPicker(sourceType: UIImagePickerControllerSourceType.camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galerie photo", style: .default, handler: { (alert:UIAlertAction!) in
            self.showPicker(sourceType: UIImagePickerControllerSourceType.photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showPicker(sourceType:UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            present(pickerController, animated: true, completion: nil)
            
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as! UIImage? {
            imageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as! UIImage? {
            imageView.image = image
        } else {
            imageView.image = nil
        }
        print(info)

        pickerController.dismiss(animated: true, completion: nil)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
