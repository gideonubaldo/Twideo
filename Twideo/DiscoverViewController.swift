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
import ProgressHUD
class DiscoverViewController: UITableViewController{
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != ""{
            return filteredUsers.count
            
        }
        return users.count
    }
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users = [NSDictionary]()
    
    var filteredUsers = [NSDictionary]()
    
    var selectedAlbumId: String?
    
    override func viewDidLoad() {
//        tableView.delegate = self
        
        tableView.dataSource = self
        searchBar.delegate = self
        definesPresentationContext = true
        
        self.tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")

        loadUsers()
        
    }
    
    
    
    //change query -> pull the comments into the comment section
    func loadUsers(){
        print("LOAD")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No curent user id")
            return
        }
       self.users = []
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
        
            print("snap \(snapshot)")
            print("key \(snapshot.key) value \(snapshot.value)")
            
            
            let userDict = snapshot.value as! NSDictionary
            self.users.append(userDict)
            
//            self.users.append(["username": snapshot.key])
            self.tableView.reloadData()
        }
            
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        if searchBar.text != ""{
        
            cell.textLabel?.text = "\(filteredUsers[indexPath.row]["username"]!)"
        } else {
            cell.textLabel?.text = "\(users[indexPath.row]["username"]!)"
            
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //are you sure?
        //ask to edit or kindly decline meeting
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you wish to share the album this user?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            
            if self.searchBar.text != ""{
                self.shareAlbum(uid: self.filteredUsers[indexPath.row]["uid"] as! String)
            }else {
                
                self.shareAlbum(uid: self.users[indexPath.row]["uid"] as! String)
            }
            
            
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            }))
        
        self.present(alert, animated: true, completion: nil)
        
        //add to other users node "user:sharedAlbum" 
    }
    func showError(){
        ProgressHUD.showError("ERROR - DID NOT ADD")
    }
    func shareAlbum(uid: String){
        
        Database.database().reference().child("user-sharedAlbums").child(uid).child(selectedAlbumId!).setValue(1) { (error, ref) in
            if error != nil{
                self.showError()
            } else {
                 ProgressHUD.showSuccess("SUCCESS")
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
       
    }
}

extension DiscoverViewController: UISearchBarDelegate, UISearchControllerDelegate{
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
        
        
        self.filteredUsers = users.filter{ user in
            
            let string = "\(user["username"])"
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
class UserCell: UITableViewCell{
    
}
