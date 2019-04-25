//
//  CommentCell.swift
//  Twideo
//
//  Created by Riley Chetwood on 4/24/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func setComment(comment: Comment) {
        commentLabel.text = comment.content
        authorLabel.text = comment.author
    }
}
