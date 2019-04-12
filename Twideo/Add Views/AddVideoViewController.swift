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
import ProgressHUD
import CoreLocation

class AddVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var videoPlayerView: UIView!
    
    var player = AVPlayer()
    let playerController = AVPlayerViewController()
    var album = NSDictionary()
    var localVideoURL: URL?
    let manager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    override func viewDidLoad() {
		
        super.viewDidLoad()
        
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            print("ENABLED")
            manager.delegate = self

            manager.desiredAccuracy = kCLLocationAccuracyBest

            manager.startUpdatingLocation()
//            manager.requestLocation()

        } else {
            print("IDK")
        }
        
        
        
        playVideo(url: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue : CLLocationCoordinate2D = manager.location?.coordinate else {
            print("Error finding lcoation")
            return
        }
        print("DID UPDATE LCOATON")
        print(locationValue.latitude)
        print(locationValue.longitude)
        self.latitude = locationValue.latitude
        self.longitude = locationValue.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
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
        print("returnnnnn")
        if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            
            localVideoURL = video
            playVideo(url: video)
            
            
        } else{
            playVideo(url: nil)
            print("ERROR")
        }
        dismiss(animated: true, completion: nil)//dismiss image picker after cancel or chosen video
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

//save video to database function and location
extension AddVideoViewController{
    
    
    
    func saveVideo(){
        
        ProgressHUD.show("Saving video. This might take a while...")
//        self.view.isUserInteractionEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        print("STARTED")
        guard let userId = Auth.auth().currentUser?.uid else {
			print("NO UID")
			return
		}
        guard let _ = localVideoURL else {
            print("No video selected")
            return
        }
        
        //save to storage
        saveVideoHelper(localUrl: localVideoURL!, userId: userId, onSuccess:{
            
            print("Success")
//            self.view.isUserInteractionEnabled = true
            UIApplication.shared.endIgnoringInteractionEvents()
            ProgressHUD.showSuccess()
            //ProgressHUD.showSuccess("Success")
            
        }, onError: {errorString in
            ProgressHUD.showError()
            print("ERROR")
//            self.view.isUserInteractionEnabled = true
            UIApplication.shared.endIgnoringInteractionEvents()
            //ProgressHUD.showError(errorString!)
            
        })
        //get url
        
    }
    
    func saveVideoHelper(localUrl: URL, userId: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String?) -> Void){
        
        let ref = Database.database().reference().child("videos").childByAutoId()
        let newVideoKey = ref.key!
        
        let storageRef = Storage.storage().reference(forURL: "gs://twideo-56273.appspot.com").child("albums").child(self.album["albumId"] as! String).child(newVideoKey)
		
		
		storageRef.putFile(from: localUrl, metadata: nil) { (metadata, error) in
			
            if error != nil{
                onError(error?.localizedDescription)
                return
			}
            storageRef.downloadURL { (videoUrl, error) in
                if error != nil{
                    print("Error downloading URL: \(error!.localizedDescription)")
                    return
                }
                guard let title = self.titleTextField.text else {
                    print("No Title")
                    onError(error?.localizedDescription)
                    return
                }
                
                guard let description = self.descriptionTextField.text else { print("NO description")
                    onError(error?.localizedDescription)
                    return
                    
                }
                guard let notes = self.notesTextField.text else {
                    print("NO notes")
                    onError(error?.localizedDescription)
                    return
                }
                
                guard let url = videoUrl?.absoluteString else{
                    print("no url")
                    onError(error?.localizedDescription)
                    return
                }
                
                guard let albumId = self.album["albumId"] as? String else{
                    print("NO ALBUM ID")
                    onError(error?.localizedDescription)
                    return
                }
                guard let lat = self.latitude else{
                    print("NO LAT")
                    onError(error?.localizedDescription)
                    return
                }
                guard let long = self.longitude else{
                    print("NO LONG")
                    onError(error?.localizedDescription)
                    return
                }
                let fileType = localUrl.pathExtension
                //"videos"
                let asset = AVURLAsset(url: localUrl)
                let durationInSeconds = asset.duration.seconds
                print("\(durationInSeconds) durationInSeconds")
                
                
                ref.updateChildValues(["id" : newVideoKey, "url" : url,"title": title, "description" : description, "albumId": albumId, "senderId": userId, "latitude": lat, "longitude": long, "fileType": fileType, "notes": notes, "duration": durationInSeconds])
                
                //"album-videos"
                Database.database().reference().child("album-videos").child(albumId).child(newVideoKey).setValue(1)
                
                onSuccess()
            }
            
            
        }
    }
}
