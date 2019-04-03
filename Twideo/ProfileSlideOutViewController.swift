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
import FBSDKCoreKit
import FacebookCore
class ProfileSlideOutViewController: UIViewController{
    
    var tableViewController: AlbumsViewController?
    @IBOutlet weak var profileImage: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        profileImage.setImage(appDelegate.userImage, for: .normal)
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
