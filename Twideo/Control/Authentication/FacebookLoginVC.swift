//
//  FacebookLoginVC.swift
//  Twideo
//
//  Created by Josh Kardos on 3/4/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
class FacebookLoginVC: UIViewController, FBSDKLoginButtonDelegate, LoginButtonDelegate{
    
    
 
    
    //facebook login tutorial: https://www.youtube.com/watch?v=8-WXdfjFvbw
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {

        facebookLoginButton.center = view.center
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile"]
        
        facebookLoginButton.sizeToFit()
//        let loginButton = LoginButton(readPermissions: [.publicProfile])
//        loginButton.center = view.center
//        self.view.addSubview(loginButton)
//        loginButton.delegate = self
        
        if let accessToken = AccessToken.current{
            print("User is already logged in")
            firebaseFacebookLogin(accessToken: accessToken.authenticationToken)
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
        

    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if ((error) != nil) {
            // Process error
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("CANCELLED")
        }
        else {
            // Navigate to other view
            firebaseFacebookLogin(accessToken: (FBSDKAccessToken.current()?.tokenString)!)
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
            
            ProgressHUD.show("Signing In")
            if let user = Auth.auth().currentUser{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
                    let _ = request?.start(completionHandler: { (connection, result, error) in
                        guard let userInfo = result as? [String: Any] else { return } //handle the error
                        if let name = userInfo["name"] as? String{
                            
                            
                            //The url is nested 3 layers deep into the result so it's pretty messy
                            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                //Download image from imageURL
                                do {
                                    let data = try Data(contentsOf: URL(string: imageURL)!)
                                    
                                    appDelegate.userImage = UIImage(data: data)
                                    
                                }
                                catch{
                                    print("Error getting image from fb")
                                    
                                }
                            } else {
                                ProgressHUD.showError("Failed to Login")
                            }
                            Database.database().reference().child("users").child(user.uid).updateChildValues(["uid" : user.uid, "username": name])
                            //                Database.database().reference().child("users").updateChildValues([user.uid:1])
                            
                            self.performSegue(withIdentifier: "loggedIn", sender: self)
                            ProgressHUD.showSuccess("Logged In")
                            print("Current firebase user is")
                            print(user)
                        } else {
                            ProgressHUD.showError("Failed to Login")
                        }
                    })
                        
                
            }
        }
    }
    
    
    
    @IBAction func emailLoginButton(_ sender: UIButton) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    self.performSegue(withIdentifier: "loggedIn", sender: nil)
                
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
}
