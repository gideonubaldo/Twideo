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

class CreateAccount: UIViewController {
    var refUser: DatabaseReference!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    @IBAction func Login(_ sender: UIButton) {
        addUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refUser = Database.database().reference().child("users");
        
    }
    
    func addUser(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refUser.childByAutoId().key
        //creating artist with the given values
        let user = ["id":key,
                    "userName": textFieldName.text! as String,
                    "userPass": textFieldPass.text! as String
        ]
        
        refUser.child(key!).setValue(user)
        
        //displaying message
        //labelMessage.text = "Artist Added"
    }
    
}

