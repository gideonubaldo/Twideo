//
//  ProfileSlideOutViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/19/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
class ProfileSlideOutViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(SideMenuManager.default.menuWidth)
        
        print(presentingViewController?.view.widthAnchor)
    }
    
    
}

extension ProfileSlideOutViewController: UISideMenuNavigationControllerDelegate{
    
}
