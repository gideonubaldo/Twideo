//
//  VideoCell.swift
//  Twideo
//
//  Created by Josh Kardos on 3/22/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit

class VideoCell: UICollectionViewCell{
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configureCell(videoModel: VideoModel){
        descriptionLabel.text = videoModel.description
    }
    
}
