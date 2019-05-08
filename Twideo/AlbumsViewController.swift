//
//  AlbumsViewController.swift
//  Twideo
//
//  Created by Josh Kardos on 3/18/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SideMenu
import Firebase
import ProgressHUD
import FacebookCore
class AlbumsViewController: UITableViewController{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //floating button bottom right, clicked to add album
    private var roundButton = UIButton()
    var isSharedAlbums = false//if false, the round button will appear
    
    var myAlbums = [NSDictionary]()
    var sharedAlbums = [NSDictionary]()
    
    var selectedAlbums = [NSDictionary](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredAlbums = [NSDictionary]()
    
    
    var albumToShareId: String?
    override func viewDidLoad() {
        tableView.delegate = self
        
        tableView.dataSource = self
        searchBar.delegate = self
        definesPresentationContext = true
        
        self.selectedAlbums = self.myAlbums
        self.title = "My Albums"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isSharedAlbums == false{
            createFloatingButton()
        }
       loadMyAlbums()
        loadSharedAlbums()
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                
            }
        }
    }
    
    
    func loadSharedAlbums(){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No curent user id")
            return
        }
        
        Database.database().reference().child("user-sharedAlbums").child(uid).observe(.childAdded) { (snapshot) in
            self.sharedAlbums = []
            let albumId = snapshot.key
            print("ADEED \(albumId)")
            Database.database().reference().child("albums").child(albumId).queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let albumDict = snapshot.value as? NSDictionary{
                    self.sharedAlbums.append(albumDict)
                    
                }
                if self.isSharedAlbums {
                    self.selectedAlbums = self.sharedAlbums
                }
                
            
            })
        }
        
    }
    
    //change query -> pull the comments into the comment section
    func loadMyAlbums(){
        print("LOAD")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No curent user id")
            return
        }
        
        Database.database().reference().child("user-albums").child(uid).child("albums").observe(.childAdded) { (snapshot) in
            self.myAlbums = []
            let albumId = snapshot.key
            print("ADEED \(albumId)")
            Database.database().reference().child("albums").child(albumId).queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let albumDict = snapshot.value as! NSDictionary
                self.myAlbums.append(albumDict)
                if !self.isSharedAlbums {
                    self.selectedAlbums = self.myAlbums
                }
                
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openSideMenu"{
            let destination = (segue.destination as! UISideMenuNavigationController)
            let slideOutMenu = (destination.children[0]) as! ProfileSlideOutViewController
            slideOutMenu.tableViewController = self//delegate
            
        } else if segue.identifier == "albumCellClicked"{
            
            let destination = (segue.destination as! IndividualAlbumViewController)
            if searchBar.text != ""{
                destination.album = self.filteredAlbums[tableView.indexPathForSelectedRow!.row]
            } else {
            destination.album = self.selectedAlbums[tableView.indexPathForSelectedRow!.row]
            }
            if isSharedAlbums == true{
                destination.isSharedAlbums = true
            } else {
                destination.isSharedAlbums = false
            }
        } else if segue.identifier == "ShowDiscover" {
            let destination = (segue.destination as! DiscoverViewController)
            destination.selectedAlbumId = self.albumToShareId
        }
        
        
        
    }
    @objc func addButtonPressed(){
        
        FBSDKProfile.loadCurrentProfile { (profile, error) in
            
            if let p = profile{
                
                let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
                let request = FBSDKGraphRequest(graphPath: "\(p.userID)/user_friends", parameters: params)
                request?.start(completionHandler: { (connection, result, error) in
                    if error != nil {
                        
                        let errorMessage = error!.localizedDescription
                        print("ERROR \(errorMessage)")
                    }else{
                        
                        /* Handle response */
                        print("Result \(result!)")
                        
                    }
                })
            } else {
                print("nope")
            }
        }
        
        
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
        
        
        if searchBar.text != ""{
            cell.titleLabel?.text = "\(filteredAlbums[indexPath.row]["title"]!)"
        } else {
            cell.titleLabel?.text = "\(selectedAlbums[indexPath.row]["title"]!)"

        }
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != ""{
            
            return filteredAlbums.count
            
        }
        return selectedAlbums.count
        
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return nil}
        
        if selectedAlbums[indexPath.row]["creatorUid"] as! String != currentUid {return nil}
        
        
        let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
        let deleteAction = UIContextualAction(style: .normal, title: deleteTitle) { (action, sourceView, completionHandler) in
            self.deleteAlbum(at: indexPath)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        let editTitle = NSLocalizedString("Edit", comment: "Edit action")
        let editAction = UIContextualAction(style: .normal, title: editTitle) { (action, sourceView, completionHandler) in
            
            
            
            let storyboard: UIStoryboard = UIStoryboard(name: "AddViews", bundle: nil)
            let editAlbumVC = storyboard.instantiateViewController(withIdentifier: "EditAlbum") as! EditAlbumViewController
            editAlbumVC.albumModel = self.selectedAlbums[indexPath.row]
            self.navigationController?.pushViewController(editAlbumVC, animated: true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let shareTitle = NSLocalizedString("Share", comment: "Share action")
        let shareAction = UIContextualAction(style: .normal, title: shareTitle) { (action, sourceView, completionHandler) in
            
            
            
            print("SHARE PRESSED")
            
            if self.searchBar.text != ""{
                self.albumToShareId = "\(self.filteredAlbums[indexPath.row]["albumId"]!)"
            } else {
                self.albumToShareId = "\(self.selectedAlbums[indexPath.row]["albumId"]!)"
                
            }
            
            
            self.performSegue(withIdentifier: "ShowDiscover", sender: nil)
            
        }
        shareAction.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        //        let favoriteTitle = NSLocalizedString("Favorite", comment: "Favorite action")
        //        let favoriteAction = UITableViewRowAction(style: .normal,
        //                                                  title: favoriteTitle) { (action, indexPath) in
        //                                                    self.tableView.dataSource?.setFavorite(true, at: indexPath)
        //        }
        //        favoriteAction.backgroundColor = .green
        
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction, shareAction])
        swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
        return swipeAction
        
    }
    

    func deleteAlbum(at indexPath: IndexPath){
        
        
        let albumId = selectedAlbums[indexPath.row]["albumId"] as! String
        
        
        //        (self.tableView.cellForRow(at: indexPath) as! AlbumTableViewCell).hideSwipe(animated: false)
        self.selectedAlbums.remove(at: indexPath.row)
        self.myAlbums.remove(at: indexPath.row)
        Storage.storage().reference().child("videos").child(albumId).delete(completion: nil)
        
        var videoIdsToDelete = [String]()
        
        Database.database().reference().child("videos").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let videoDict = snapshot.value as? [String: NSDictionary] else {
                return
            }
            
            for (_, video) in videoDict {
                
                videoIdsToDelete.append(video["id"] as! String)
                
            }
            
            for i in 0..<videoIdsToDelete.count{
                Database.database().reference().child("videos").child(videoIdsToDelete[i]).removeValue()
            }
            
            
        }
        
        
        
        Database.database().reference().child("albums").child(albumId).removeValue()
        Database.database().reference().child("album-videos").child(albumId).removeValue()
        Database.database().reference().child("user-albums").child((Auth.auth().currentUser?.uid)!).child("albums").child(albumId).removeValue()
        
        
    }
    
}

extension AlbumsViewController: UISearchBarDelegate, UISearchControllerDelegate{
    func updateSearchResults(for searchBar: UISearchBar) {
        filterContent(searchText: searchBar.text!)
        
    }
    
    //search ends
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("CLICKED")
        return true
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    //searhc begins
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    //cancel clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    //search clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func filterContent(searchText: String){
        
        
        self.filteredAlbums = selectedAlbums.filter{ album in
            
            let string = "\(album["title"])"
            print(string)
            return(string.lowercased().contains(searchText.lowercased()))
            
        }
        
        tableView.reloadData()
        
        
    }
    
    
    
    //search bar text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: self.searchBar)
        //        if searchBar.text?.count == 0 {
        //
        //            //Disaptch Queue object assigns projects to different thread
        //            DispatchQueue.main.async {
        //                searchBar.resignFirstResponder()
        //            }
        //        }
    }
    
}
