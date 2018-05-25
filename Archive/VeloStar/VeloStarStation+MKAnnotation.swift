//
//  VeloStarStation+MKAnnotation.swift
//  VeloStar
//
//  Created by Baptiste Alexandre on 24/05/2018.
//  Copyright © 2018 ALXDR. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension VeloStarStation: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {

        guard let latitude = latitude, let longitude = longitude else {
            return CLLocationCoordinate2D(latitude: 48.1132635, longitude: -1.682506)
        }
        
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)

        return CLLocationCoordinate2D(latitude: latDegrees!, longitude: longDegrees!)
    }
    
    public var title: String? {
        return name
    }
    
    public var distanceString: String? {
        if let stationDist = distance as Double? {
            
            if (stationDist == 0) {
                return ""
            }
            return String(format: "%.1f km", stationDist/1000)
            
        } else {
            return ""
        }
    }
    
}

