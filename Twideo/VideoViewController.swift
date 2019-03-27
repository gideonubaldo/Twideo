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
    var videoModel: VideoModel?
    
    override func viewDidLoad() {
		
		//configureview calls play video
        if let _ = self.videoModel{
            configureView()
        }
		
    }
	
	
	func configureView(){
        
        self.descriptionLabel.text = videoModel?.description
        self.playVideo()
        
	}
	
    func playVideo() {
        
        
        if let _ = videoModel!.url {
            player = AVPlayer(url: videoModel!.url!)
            playerController.player = player
            self.addChild(playerController)
            
            let topHalf = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
            // Add your view Frame
            playerController.view.frame = topHalf
            
            // Add subview in your view
            self.view.addSubview(playerController.view)
            
            player.play()
        }
        
        
    }
    
    func stopVideo() {
        player.pause()
    }
}
