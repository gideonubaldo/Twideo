//
//  TableViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/5/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import FirebaseStorage
import FirebaseDatabase
class VideoViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    var videoId: String?
    var videoUrl: String?
    var videoDescription: String?
    override func viewDidLoad() {
		
		//configureview calls play video
		configureView()
    }
	
	
	func configureView(){
		Database.database().reference().child("videos").child(videoId!).observe(.value, with: { (snapshot) in
			
			let snap = snapshot.value as! NSDictionary
			
			print(snap["description"] as Any)
			
			self.descriptionLabel.text = (snap["description"] as! String)
			
			self.videoUrl = (snap["url"] as! String)
			
			self.playVideo()
		})
	}
	
    func playVideo() {
        
        
        
        let videoURL = NSURL(string: self.videoUrl!)
		print("URL \(videoURL)")
        player = AVPlayer(url: videoURL! as URL)
        playerController.player = player
        self.addChild(playerController)

        let topHalf = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
        // Add your view Frame
        playerController.view.frame = topHalf

        
        let descriptionLabel = UILabel()
        descriptionLabel.text = videoDescription
        // Add subview in your view
        self.view.addSubview(playerController.view)
        self.view.addSubview(descriptionLabel)
        player.play()
    }
    
    func stopVideo() {
        player.pause()
    }
}
