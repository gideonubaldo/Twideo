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


class ProfileViewController: UIViewController , FBSDKLoginButtonDelegate{
  

    @IBOutlet weak var albumCountTitle: UILabel!
    @IBOutlet weak var videoCountTitle: UILabel!
    @IBOutlet weak var shareCountTitle: UILabel!
    
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    
    @IBOutlet weak var logoutButton: FBSDKLoginButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        albumCountTitle.numberOfLines = 0
        [albumCountTitle .sizeToFit()]
        logoutButton.delegate = self
        
        logoutButton.sizeToFit()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        dismiss(animated: true, completion: nil)
    }
    


}
