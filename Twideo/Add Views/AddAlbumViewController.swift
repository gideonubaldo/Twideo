//
//  AddAlbumViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/20/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddAlbumViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var delegate = AlbumsViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 4
    }
    @IBAction func submitPressed(_ sender: Any) {
        
        //check text fields, must be valid input
        if titleTextField.text!.isValid() && descriptionTextField.text!.isValid(){
            
            
            guard let userID = Auth.auth().currentUser?.uid else{print("NO UID");return}
            guard let title = titleTextField.text else{print("NO title text");return}
            guard let description = descriptionTextField.text else { print("NO description");return}
            
            
            let ref = Database.database().reference().child("user-albums").child(userID).child("albums").childByAutoId()
            ref.setValue(1)
            
            let newAlbumId = ref.key!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            Database.database().reference().child("albums").child(newAlbumId).setValue(["title": title, "description": description, "creatorUid": userID, "albumId" : newAlbumId, "timestamp": dateFormatter.string(from: NSDate() as Date)])
            
            
            self.titleTextField.text = nil
            self.descriptionTextField.text = nil
            
            //valid
            self.navigationController?.popToRootViewController(animated: false)
                
            
        
            
        } else {
            //not valid
            
            print("There is an empty text field")
            
        }
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
    
}

extension String{
    
    func isValid()-> Bool{
        if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            return false
        } else {
            return true
        }
    }
    
}
