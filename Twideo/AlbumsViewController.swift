//
//  AlbumsViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/18/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import SideMenu
import Firebase
import SwipeCellKit
import ProgressHUD
class AlbumsViewController: UITableViewController, SwipeTableViewCellDelegate{
    
    
    
    
    //floating button bottom right, clicked to add album
    private var roundButton = UIButton()
    var isSharedAlbums = Bool()//if false, the round button will appear
    
    var myAlbums = [NSDictionary]()
    var sharedAlbums = [NSDictionary]()
    
    var selectedAlbums = [NSDictionary](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        loadMyAlbums()
        
        
        
        //        loadSharedAlbums()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isSharedAlbums == false{
            createFloatingButton()
        }
        tableView.reloadData()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                
            }
        }
    }
    func loadMyAlbums(){
        
        myAlbums = []
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No curent user id")
            return
        }
        
        Database.database().reference().child("user-albums").child(uid).child("albums").observe(.childAdded) { (snapshot) in
            
            let albumId = snapshot.key
            print(albumId)
            Database.database().reference().child("albums").child(albumId).queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let albumDict = snapshot.value as! NSDictionary
                self.myAlbums.append(albumDict)
                self.selectedAlbums = self.myAlbums
                
            })
        }
        
        Database.database().reference().child("albums").observe(.childChanged) { (snapshot) in
            
            self.tableView.reloadData()
            
            
            
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openSideMenu"{
            let destination = (segue.destination as! UISideMenuNavigationController)
            let slideOutMenu = (destination.children[0]) as! ProfileSlideOutViewController
            slideOutMenu.tableViewController = self//delegate
            
        } else if segue.identifier == "albumCellClicked"{
            
            let destination = (segue.destination as! IndividualAlbumViewController)
            destination.album = self.selectedAlbums[tableView.indexPathForSelectedRow!.row]
            if isSharedAlbums == true{
                destination.isSharedAlbums = true
            } else {
                destination.isSharedAlbums = false
            }
        }
        
        
        
    }
    @objc func addButtonPressed(){
        //        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        //        let request = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params)
        //        request?.start(completionHandler: { (connection, result, error) in
        //            if error != nil {
        //
        //                let errorMessage = error!.localizedDescription
        //
        //            }else{
        //
        //                /* Handle response */
        //                print(result)
        //
        //            }
        //        })
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "AddViews", bundle: nil)
        let createAlbumVC = storyboard.instantiateViewController(withIdentifier: "CreateAlbum") as! AddAlbumViewController
        createAlbumVC.delegate = self
        navigationController?.pushViewController(createAlbumVC, animated: true)
        
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "albumCellClicked", sender: self)
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumTableViewCell
        
        cell.titleLabel?.text = "\(selectedAlbums[indexPath.row]["title"]!)"
        
        cell.delegate = self
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedAlbums.count
        
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        guard orientation == .right else { return nil }
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return nil}
        
        if selectedAlbums[indexPath.row]["creatorUid"] as! String != currentUid {return nil}
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            
            print("DELETE PRESSED")
            //notification
            let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this album?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Default action"), style: .default, handler: { _ in
                self.deleteAlbum(at: indexPath)}))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        deleteAction.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            
            print("EDIT PRESSED")
            
            
            let albumId = self.selectedAlbums[indexPath.row]["albumId"] as! String
            
            let albumRef = Database.database().reference().child("albums").child(albumId)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "AddViews", bundle: nil)
            let editAlbumVC = storyboard.instantiateViewController(withIdentifier: "EditAlbum") as! EditAlbumViewController
            editAlbumVC.albumModel = self.selectedAlbums[indexPath.row]
            self.navigationController?.pushViewController(editAlbumVC, animated: true)
            
        }
        editAction.image = UIImage(named: "edit")
        editAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        editAction.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        
        
        let shareAction = SwipeAction(style: .default, title: "Share") { (action, indexPath) in
            
            print("SHARE PRESSED")
        }
        shareAction.image = UIImage(named: "share")
        shareAction.backgroundColor = #colorLiteral(red: 0.8600481153, green: 0.8700754046, blue: 0.8765537739, alpha: 1)
        shareAction.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return [deleteAction, editAction, shareAction]
    }
    
    func deleteAlbum(at indexPath: IndexPath){
        let albumId = selectedAlbums[indexPath.row]["albumId"] as! String
        
        Database.database().reference().child("albums").child(albumId).removeValue()
        Database.database().reference().child("album-videos").child(albumId).removeValue()
        Database.database().reference().child("user-albums").child((Auth.auth().currentUser?.uid)!).child("albums").child(albumId).removeValue()
        
        (self.tableView.cellForRow(at: indexPath) as! AlbumTableViewCell).hideSwipe(animated: false)
        self.selectedAlbums.remove(at: indexPath.row)
        
        
        
    }
    
}

