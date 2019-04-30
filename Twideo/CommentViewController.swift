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
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        loadComments()
        //comments = createArray()
    }
    
    @IBAction func onClickReply(_ sender: Any) {
        if(commentTextBox.hasText){
            let text = commentTextBox.text
            if(text!.count>140){
                print("message too long")
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let videoID = videoModel?.id
            ref.child("comments").child(videoID ?? "No video ID provided").childByAutoId().setValue(["author": Auth.auth().currentUser?.uid, "content": commentTextBox.text, "timeStamp": dateFormatter.string(from: NSDate() as Date) as NSString])
        commentTextBox.text = ""
        }
        else{
            print("no text")
        }
        
        
    }
    
//    func createArray() -> [Comment] {
//        var tempArray: [Comment] = []
//        let testComment = Comment(videoID: "1", author: "Lebron", content: testString     ?? "not passed", timestamp: NSDate().timeIntervalSince1970)
//
//        tempArray.append(testComment)
//        return tempArray;
//    }
    
//    // Listen for new comments in the Firebase database
//    commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
//    self.comments.append(snapshot)
//    self.tableView.insertRows(at: [IndexPath(row: self.comments.count-1, section: self.kSectionComments)], with: UITableView.RowAnimation.automatic)
//    })
//    // Listen for deleted comments in the Firebase database
//    commentsRef.observe(.childRemoved, with: { (snapshot) -> Void in
//    let index = self.indexOfMessage(snapshot)
//    self.comments.remove(at: index)
//    self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionComments)], with: UITableView.RowAnimation.automatic)
//    })
    
    
    
    func loadComments(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("comments").child((videoModel?.id!)!).queryOrdered(byChild: "timeStamp").observe(.childAdded, with: { (snapshot) in
            //print("snapshot:\(snapshot.value)" )
            let commentContent = snapshot.value! as? NSDictionary
            //print("commentContent:\(commentContent)")
            let stringArray = commentContent?.allValues as! [String]
            var newComment = Comment(videoID: "videoID", author: stringArray[2], content: stringArray[0], timestamp: stringArray[2])
                self.comments.append(newComment)
               self.tableView.reloadData()
            
            
            
        }
    )
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
