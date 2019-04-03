//
//  EditAlbumViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 4/3/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class EditAlbumViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var albumModel: NSDictionary?
    
    override func viewDidLoad() {
        
        guard let title = albumModel!["title"] as? String else {
            print("ERROR GETTING ALBUM TITLE")
            return
        }
        guard let description = albumModel!["description"] as? String else {
            print("ERROR GETTING ALBUM Descritpion")
            return
        }
        

        titleTextField.text = title
        descriptionTextField.text = description
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if titleTextField.text!.isValid() && descriptionTextField.text!.isValid(){

            
            let ref = Database.database().reference().child("albums").child(albumModel!["albumId"] as! String)
            //valid
            
            ref.updateChildValues(["title": titleTextField.text, "description": descriptionTextField.text])
        self.navigationController?.popToRootViewController(animated: false)
            
            
            
        } else {
            //not valid
            
            print("There is an empty text field")
            
        }
    }
}
