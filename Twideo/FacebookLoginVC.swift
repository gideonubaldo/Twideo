//
//  FacebookLoginVC.swift
//  Twideo
//
//  Created by Josh Kardos on 3/4/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit

import FacebookCore
import FacebookLogin
import FirebaseAuth
import FirebaseDatabase
class FacebookLoginVC: UIViewController, LoginButtonDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.center = view.center
        self.view.addSubview(loginButton)
        loginButton.delegate = self
        
        if let accessToken = AccessToken.current{
            print("User is already logged in")
            firebaseFacebookLogin(accessToken: accessToken.authenticationToken)
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("User logged in")
        
        switch result{
        case .failed(let err):
            print(err)
        case .cancelled:
            print("CANCELLED")
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("SUCCESS")
            firebaseFacebookLogin(accessToken: accessToken.authenticationToken)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("User logged out")
    }
    
    
    func firebaseFacebookLogin(accessToken: String){
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let error = error{
                print("Firebase login errror")
                print("\(error)")
                return
            }
            print("Firebase login done")
            if let user = Auth.auth().currentUser{
                Database.database().reference().child("users").updateChildValues([user.uid:1])
                self.performSegue(withIdentifier: "loggedIn", sender: self)
                print("Current firebase user is")
                print(user)
            }
        }
    }
    
}
