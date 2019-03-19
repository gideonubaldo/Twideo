//
//  Map.swift
//  Twideo
//
//  Created by Chad Gorham on 3/6/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class MapViewController: UIViewController {
    //mapkit tutorial: https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        map.centerCoordinate.latitude = 37.3352
        map.centerCoordinate.longitude = -121.8811
        let region = MKCoordinateRegion(center: map.centerCoordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        map.setRegion(map.regionThatFits(region), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = map.centerCoordinate
        map.addAnnotation(annotation)
        
    }
    
}
