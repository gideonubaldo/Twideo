//
//  CommentViewController.swift
//
//
//  Created by Riley Chetwood on 4/17/19.
//
import Foundation
import UIKit
import FirebaseDatabase
import UIKit
import FBSDKCoreKit
import SideMenu
import Firebase
import ProgressHUD

class CommentViewController: UIViewController {
    
    var comments: [Comment] = []
    var videoModel: VideoModel?
    var testString: String?
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        comments = createArray()
    }
    
    @IBAction func onClickReply(_ sender: Any) {
        
    }
    
    func createArray() -> [Comment] {
        var tempArray: [Comment] = []
        let testComment = Comment(videoID: "1", author: "Lebron", content: testString     ?? "not passed", timestamp: NSDate().timeIntervalSince1970)
        
        tempArray.append(testComment)
        return tempArray
    }
    
    //change query -> pull the comments into the comment section
    func loadMyComments(){
        print("LOAD")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No curent user id")
            return
        }
        //EDIT THIS TO BE CONTEXT OF COMMENTS
//        Database.database().reference().child("user-albums").child(uid).child("albums").observe(.childAdded) { (snapshot) in
//            self.myAlbums = []
//            let albumId = snapshot.key
//            print("ADEED \(albumId)")
//            Database.database().reference().child("albums").child(albumId).queryOrdered(byChild: "title").observeSingleEvent(of: .value, with: { (snapshot) in
//
//                let albumDict = snapshot.value as! NSDictionary
//                self.myAlbums.append(albumDict)
//                if !self.isSharedAlbums {
//                    self.selectedAlbums = self.myAlbums
//                }
//
//            })
        }
    }
    
}
extension CommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        cell.setComment(comment: comment)
        
        return cell
    }
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int{
        return comments.count
    }
}
