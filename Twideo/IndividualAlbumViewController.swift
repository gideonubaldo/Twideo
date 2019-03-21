//
//  IndividualAlbumViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/18/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit

class IndividualAlbumViewController: UICollectionViewController{
    
    var album: NSDictionary?
    var roundButton = UIButton()
    var isSharedAlbums = Bool()//if false, the round button will appear
    
    override func viewDidLoad() {
        print("DIDLOAD")
        
        if let album = album {
            print( album["title"] as! String)
            navigationItem.title = (album["title"] as! String)
        }
        
        if isSharedAlbums == false{
            createFloatingButton()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                
            }
        }
    }
   
    
    func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        
        // Make sure you replace the name of the image:
        roundButton.setImage(UIImage(named:"NAME OF YOUR IMAGE"), for: .normal)
        
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 15),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: 15),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 75),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 75)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = 37.5
            // Add a black shadow:
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            // Add a pulsing animation to draw attention to button:
            self.roundButton.layer.backgroundColor = #colorLiteral(red: 0.537254902, green: 0, blue: 0, alpha: 1)
            
            self.roundButton.setTitle("+", for: .normal)
            self.roundButton.titleLabel?.font = UIFont(name: (self.roundButton.titleLabel?.font.fontName)!, size: 45)
            self.roundButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            //            self.roundButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.4
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
        
        roundButton.addTarget(self, action: #selector(addButtonPressed), for: UIControl.Event.touchUpInside)
        
    }
    @objc func addButtonPressed(){
        
        //        let storyboard: UIStoryboard = UIStoryboard(name: "AddViews", bundle: nil)
        //        let createAlbumVC = storyboard.instantiateViewController(withIdentifier: "CreateAlbum") as! AddAlbumViewController
        //        createAlbumVC.delegate = self
        //        navigationController?.pushViewController(createAlbumVC, animated: true)
        
        print("add pressed")
        
    }
    
}
