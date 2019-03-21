//
//  ProfileSlideOutViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/19/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
class ProfileSlideOutViewController: UIViewController{
    
    var tableViewController: AlbumsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    @IBAction func myAlbumsPressed(_ sender: Any) {
        tableViewController!.isSharedAlbums = false
        tableViewController!.selectedAlbums = tableViewController!.myAlbums
        
    }
    
    @IBAction func sharedAlbumsPressed(_ sender: Any) {
        
        tableViewController!.isSharedAlbums = true//will cause add button to disappear
        tableViewController!.selectedAlbums = tableViewController!.sharedAlbums
        
    
    }
    
    
}

extension ProfileSlideOutViewController: UISideMenuNavigationControllerDelegate{
    
    
    
    
    
    
}
