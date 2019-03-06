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
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        map.centerCoordinate.latitude = 37.3352
        map.centerCoordinate.longitude = -121.8811
        
    }
    
}
