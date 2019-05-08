//
//  ProfileViewController.swift
//  Twideo
//
//  Created by Gideon Ubaldo on 3/5/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import Firebase

class ProfileViewController: UIViewController{
  

    @IBOutlet weak var albumCountTitle: UILabel!
    @IBOutlet weak var videoCountTitle: UILabel!
    @IBOutlet weak var shareCountTitle: UILabel!
    
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        albumCountTitle.numberOfLines = 0
        [albumCountTitle .sizeToFit()]
        
        logoutButton.sizeToFit()
    }

    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            if AccessToken.current != nil{
                //logged in with facebook
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let signInVC = storyboard.instantiateViewController(withIdentifier: "Login")
            
            present(signInVC, animated: true, completion: nil)
            
        } catch let logoutError{
            
            print(logoutError)
            
        }
        
    }
    

}
