//
//  CommentViewController.swift
//
//
//  Created by Riley Chetwood on 4/17/19.
//

import Foundation
import UIKit
import FirebaseDatabase

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
        let testComment = Comment(videoID: "1", author: "Lebron", content: testString 	?? "not passed", timestamp: NSDate().timeIntervalSince1970)
    
        tempArray.append(testComment)
        return tempArray
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
