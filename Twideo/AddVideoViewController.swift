//
//  AddVideoViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/21/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Firebase

class AddVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var videoPlayerView: UIView!
    var player = AVPlayer()
    let playerController = AVPlayerViewController()
    var album = NSDictionary()
    var localVideoURL: URL?
    
    
    @IBOutlet weak var descriptionTextField: UITextField!
    override func viewDidLoad() {
		
        super.viewDidLoad()
        playVideo(url: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        saveVideo()
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func chooseVideoPressed(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.mediaTypes = ["public.movie"]
        //access to extension
        pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
        present(pickerController, animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            
            localVideoURL = video
            playVideo(url: video)
            
            
        } else{
            playVideo(url: nil)
            print("ERROR")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func playVideo(url: URL?){
        
        if let url = url{
		
            player = AVPlayer(url: url)
            
        } else {
            player = AVPlayer()
        }
        playerController.player = player
        playerController.view.frame = videoPlayerView.frame
        videoPlayerView.addSubview(playerController.view)
        
    }
}

//save video to database function
extension AddVideoViewController {
    
    
    func saveVideo(){
        
        guard let userId = Auth.auth().currentUser?.uid else {
			print("NO UID")
			return
		}
        guard let _ = localVideoURL else {
            print("No video selected")
            return
        }

        //save to storage
        saveVideoHelper(url: localVideoURL!, userId: userId, onSuccess:{
            
            print("Success")
            //ProgressHUD.showSuccess("Success")
            self.performSegue(withIdentifier: "signUpToDaySelect", sender: nil)
            
        }, onError: {errorString in
            
            print("ERROR")
            //ProgressHUD.showError(errorString!)
            
        })
        //get url
        
    }
    
    func saveVideoHelper(url: URL, userId: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String?) -> Void){
        
        let ref = Database.database().reference().child("videos").childByAutoId()
        let newVideoKey = ref.key!
        
        let storageRef = Storage.storage().reference(forURL: "gs://twideo-56273.appspot.com").child("videos").child(userId).child(newVideoKey)
		
		
		storageRef.putFile(from: url, metadata: nil) { (metadata, error) in
			
            if error != nil{
                onError(error?.localizedDescription)
                return
			}
            storageRef.downloadURL { (videoUrl, error) in
                if error != nil{
                    print("Error downloading URL: \(error!.localizedDescription)")
                    return
                }
                
                guard let description = self.descriptionTextField.text else { print("NO description");return}
                
                
                guard let url = videoUrl?.absoluteString else{
                    print("no url")
                    return
                }
                
                guard let albumId = self.album["albumId"] as? String else{
                    print("NO ALBUM ID")
                    return
                }
                //"videos"
               
                print(newVideoKey)
                ref.updateChildValues(["id" : newVideoKey, "url" : url, "description" : description, "albumId": albumId, "senderId": userId])
                
                //"album-videos"
                Database.database().reference().child("album-videos").child(albumId).child(newVideoKey).setValue(1)
            }
            
            
        }
    }
}
