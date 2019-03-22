//
//  ProfileViewController.swift
//  Twideo
//
//  Created by Gideon Ubaldo on 3/5/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var albumCountTitle: UILabel!
    @IBOutlet weak var videoCountTitle: UILabel!
    @IBOutlet weak var shareCountTitle: UILabel!
    
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        albumCountTitle.numberOfLines = 0
        [albumCountTitle .sizeToFit()]
        
    }
    


}
