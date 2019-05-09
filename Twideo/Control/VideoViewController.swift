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
import FirebaseDatabase
class VideoViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var playerControllerView: UIView!
    
    
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    var videoModel: VideoModel?
    
    override func viewDidLoad() {
		
		//configureview calls playVideo()
        if let _ = self.videoModel{
            configureView()
        }
		
    }
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPhotoLocation"{
            if let vc = segue.destination as? MapViewController{
                vc.videoModel = videoModel!
            }
        }
        if segue.identifier == "viewComments"{
            if let vc = segue.destination as? CommentViewController{
                vc.videoModel = videoModel
            }
        }
    }
	func configureView(){
        
        self.descriptionLabel.text = " \(videoModel!.description!)"
        self.notesLabel.text = "\(videoModel!.notes!)"
        self.formatLabel.text = "\(videoModel!.fileType!)"
        self.lengthLabel.text = "\(videoModel!.duration!.rounded(toPlaces: 2)) sec."
    
        self.playVideo()
    
	}
	
    func playVideo() {
        
        let topHalf = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
        
        playerControllerView.frame = topHalf
        
        if let _ = videoModel!.url {
            
            player = AVPlayer(url: videoModel!.url!)
            playerController.player = player
            self.addChild(playerController)
            
            
            // Add your view Frame
            playerController.view.frame = topHalf
            playerControllerView.addSubview(playerController.view)
//            // Add subview in your view
//            self.view.addSubview(playerController.view)
//
//            player.play()
        }
        
        
    }
    
    func stopVideo() {
        player.pause()
    }
}


extension Double {
    
    public func rounded(toPlaces places: Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
    }
}
