//
//  VideoCell.swift
//  Twideo
//
//  Created by Josh Kardos on 3/22/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoCell: UICollectionViewCell {
    
	@IBOutlet weak var videoPlayerView: UIView!
	@IBOutlet weak var descriptionLabel: UILabel!
	let playerController = AVPlayerViewController()
	var player = AVPlayer()
	
	
    func configureCell(videoModel: VideoModel){
		
		self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        player = AVPlayer(url: videoModel.url!)
        playerController.showsPlaybackControls = false
        
		playerController.player = player
		playerController.view.frame = videoPlayerView.frame
		videoPlayerView.addSubview(playerController.view)
		
        
        
        descriptionLabel.text = videoModel.title
    }
	
   

}
