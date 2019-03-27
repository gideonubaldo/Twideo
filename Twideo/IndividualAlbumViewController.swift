//
//  IndividualAlbumViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/18/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import Firebase

class IndividualAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let segueIdentifier = "videoCellClicked"
    var album: NSDictionary?
    var roundButton = UIButton()
    var isSharedAlbums = Bool()//if false, the round button will appear
    let reuseIdentifier = "VideoCell"
	
	var clickedVideoId: String?
	
    var videos = [VideoModel]()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        loadVideos()
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        if let album = album {
            navigationItem.title = (album["title"] as! String)
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if isSharedAlbums == false{
            createFloatingButton()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                
            }
        }
    }
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == segueIdentifier{
			if let vc = segue.destination as? VideoViewController{
				
				if let id = clickedVideoId{
					vc.videoId = clickedVideoId
				} else{
					print("NO VIDEO ID")
				}
			} else {
				print("COULD NOT CAST TO VIDEOVC")
			}
			
		}
	}
    func loadVideos(){
        
        guard let albumId = album!["albumId"] as? String else{
            print("tried to load videos but failed")
            return
        }
        Database.database().reference().child("album-videos").child(albumId).observe(.childAdded) { (snapshot) in
            
            let videoId = snapshot.key
            Database.database().reference().child("videos").child(videoId).queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in
				
                let videoDict = snapshot.value as! NSDictionary
                let videoModel = VideoModel(dictionary: videoDict)
                self.videos.append(videoModel)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
            
            
        }
        
        
        
        
        
    }
    //selected cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		clickedVideoId = videos[indexPath.row].id
		performSegue(withIdentifier: segueIdentifier, sender: nil)
        
    }
    
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return videos.count
        
    }
    
    //text to fill cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell

        cell.configureCell(videoModel: videos[indexPath.row])

        // Configure the cell
        return cell


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
        
        let storyboard: UIStoryboard = UIStoryboard(name: "AddViews", bundle: nil)
        let createVideoVC = storyboard.instantiateViewController(withIdentifier: "CreateVideo") as! AddVideoViewController
        createVideoVC.album = album!
        //        createAlbumVC.delegate = self
        
        //        let createVideoVC = AddVideoViewController()
        present(createVideoVC, animated: true, completion: nil)
        //                navigationController?.pushViewController(createVideoVC, animated: true)
		
        
    }
    
}

class VideoModel{
    
    var albumId: String?
    var senderId: String?
    var description: String?
    var id: String?
    var title: String?
    var url: String?
    
    //video dictionary
    init(dictionary: NSDictionary){
        guard let albumId = dictionary["albumId"] as? String else{
            print("no album id")
            return
        }
        self.albumId = albumId
		senderId = (dictionary["senderId"] as! String)
		description = (dictionary["description"] as! String)
		id = (dictionary["id"] as! String)
		url = (dictionary["url"] as! String)
        
        
    }
    
    
    
}
