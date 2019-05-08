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
import FBSDKLoginKit
import FacebookCore
import FirebaseAuth
class ProfileSlideOutViewController: UIViewController{
    
    var tableViewController: AlbumsViewController?
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    let logOutSegue = "logOut"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        profileImage.setImage(appDelegate.userImage ?? UIImage(named: "profileplacer"), for: .normal)
    }
    
    @IBAction func myAlbumsPressed(_ sender: Any) {
        tableViewController!.isSharedAlbums = false
        tableViewController!.selectedAlbums = tableViewController!.myAlbums
        tableViewController!.title = "My Albums"
        
    }
    
    @IBAction func sharedAlbumsPressed(_ sender: Any) {
        
        tableViewController!.isSharedAlbums = true//will cause add button to disappear
        tableViewController!.selectedAlbums = tableViewController!.sharedAlbums
        tableViewController!.title = "Shared Albums"
        
    }
    
    
}

extension ProfileSlideOutViewController: UISideMenuNavigationControllerDelegate{
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            if AccessToken.current != nil{
                //logged in with facebook
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            try Auth.auth().signOut()
            self.dismiss(animated: false) {
                self.tableViewController?.performSegue(withIdentifier: self.logOutSegue, sender: nil)
            }
            
        } catch let logoutError{
            
            print(logoutError)
            
        }
    }
    
    
    
    
}
