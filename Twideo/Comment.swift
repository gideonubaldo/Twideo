//
//  Comment.swift
//  Twideo
//
//  Created by Riley Chetwood on 4/25/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    let videoID: String
    let author:String
    let content:String
    let timestamp: String
    
    init(videoID: String, author: String, content: String, timestamp: String) {
        self.videoID = videoID
        self.author = author
        self.content = content
        self.timestamp = timestamp
    }
}
