//
//  CreateAccount.swift
//  Twideo
//
//  Created by Chad Gorham on 3/5/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
class CreateAccount: UIViewController {
    var refUser: DatabaseReference!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func Login(_ sender: UIButton) {
        addUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refUser = Database.database().reference().child("users");
        
    }
    
    func addUser(){
        
            
            if textFieldName.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                Auth.auth().createUser(withEmail: textFieldName.text!, password: textFieldPass.text!) { (user, error) in
                    
                    if error == nil {
                        print("You have successfully signed up")
                        //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                        
    
                        if let uid = Auth.auth().currentUser?.uid{
                            
                            if self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                                self.signUpUser(uid: uid, username: self.usernameTextField.text!)
                                
                            } else {
                                ProgressHUD.showError("Please choose username")
                            }
                            
                            
                            
                            
                        }
                        
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    
    func signUpUser(uid: String, username: String ){
        
        //get referenece to users in the database
        let usersRef = Database.database().reference().child("users")
        
        
        
        //save into database user(username, email, major, school profileImage,...)
       
        usersRef.child(uid).setValue(["uid": uid, "username" : username]) { (err, ref) in
            if err == nil{
                ProgressHUD.showSuccess("Successfully created user")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                self.present(vc!, animated: true, completion: nil)
            } else{
                ProgressHUD.showError("ERROR when creating user")
            }
        }
        
    }
    
    
}

