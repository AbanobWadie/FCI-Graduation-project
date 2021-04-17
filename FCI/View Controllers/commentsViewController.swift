//
//  commentsViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 7/31/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class commentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTxt: UITextField!
    
    var postId = String()
    var comments = [[String : Any]]()
    var replaysNum = [Int]()
    var refreshControl = UIRefreshControl()
    var replayFlag = false
    var replaySection = -1
    var addReplayTxt = UITextField()
    var addReplayBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupPostCommentsAPI()
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @IBAction func addCommentAction(_ sender: Any) {
        if addCommentTxt.text! != "" {
            
            
            setupCommentPostAPI()
        }else {
            let alert = UIAlertController(title: "sorry", message: "You must write something in comment", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension commentsViewController {
    func layouts() {
        addCommentTxt.layer.masksToBounds = true
        addCommentTxt.layer.cornerRadius = addCommentTxt.frame.height/2
        addCommentTxt.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            addCommentTxt.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func setupPostCommentsAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getcomments(userId: userId, postId: postId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.comments = responseValue["comments"] as! [[String : Any]]
                    print(self.comments)
                    
                    var i = 0
                    self.replaysNum.removeAll()
                    for _ in self.comments {
                        let comment = self.comments[i]
                        let replays = comment["replayes"] as! [[String : Any]]
                        self.replaysNum.append(replays.count)
                        i += 1
                    }
                    
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }else{
                    let alert = UIAlertController(title: "sorry", message: "Something went wrong...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: response.error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func setupCommentPostAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["commentContent" : addCommentTxt.text!, "postId" : postId, "studentId" : userId]
        
        Alamofire.request(APIs.CommentPost(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.setupPostCommentsAPI()
                    
                    self.addCommentTxt.text! = ""
                }else{
                    print(responseValue["message"]!)
                    let alert = UIAlertController(title: "sorry", message: "Somethind went Wrong...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: "Server Down", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func setupCommentLikeAPI(commentId: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["commentId" : commentId, "studentId" : userId]
        
        Alamofire.request(APIs.likeComment(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    
                }else{
                    print(responseValue["message"]!)
                    let alert = UIAlertController(title: "sorry", message: "Somethind went Wrong...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: "Server Down", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    func setupReplayCommentAPI(commentId: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["replayComment" : addReplayTxt.text!, "commentId" : commentId, "studentId" : userId]
        
        Alamofire.request(APIs.replayComment(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.replayFlag = false
                    self.replaySection = -1
                    self.addReplayBtn.tag = 2
                    self.setupPostCommentsAPI()
                    
                    self.addReplayTxt.text! = ""
                }else{
                    print(responseValue["message"]!)
                    let alert = UIAlertController(title: "sorry", message: "Somethind went Wrong...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: "Server Down", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func setupReplayLikeAPI(replayId: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["replayId" : replayId, "studentId" : userId]
        
        Alamofire.request(APIs.likeReplay(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    
                }else{
                    let alert = UIAlertController(title: "sorry", message: "Something went wrong...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: "Server Down", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}

extension commentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if replayFlag && section == replaySection {
            return replaysNum[section] + 2
        }else{
            return replaysNum[section] + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowCount = replaysNum[indexPath.section] + 2
        
        if indexPath.row == 0 {
            let comment = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! commentTableViewCell
            
            let singleComment = comments[indexPath.section]
            let commentUploader = singleComment["commentUploader"] as! [String : String]
            
            let userImageBtn = comment.userImageBtn!
            userImageBtn.sd_setBackgroundImage(with: URL(string: commentUploader["ProfileImagePath"]!), for: .normal, completed: nil)
            userImageBtn.layer.masksToBounds = true
            userImageBtn.layer.cornerRadius = userImageBtn.frame.height/2
            userImageBtn.layer.borderWidth = 2
            userImageBtn.layer.borderColor = UIColor.label.cgColor
            userImageBtn.tag = indexPath.section
            userImageBtn.addTarget(self, action: #selector(userNameImageAction), for: .touchUpInside)
            
            let userNameBtn = comment.userNameBtn!
            userNameBtn.setTitle(commentUploader["Name"]!, for: .normal)
            userNameBtn.tag = indexPath.section
            userNameBtn.addTarget(self, action: #selector(userNameImageAction), for: .touchUpInside)
            
            let commentLbl = comment.commentLbl!
            commentLbl.text! = singleComment["content"] as! String
            
            let likeBtn = comment.likeBtn!
            if singleComment["isLiked"] as! Bool {
                likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeBtn.tintColor = .red
            }else {
                likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                likeBtn.tintColor = .label
            }
            likeBtn.tag = indexPath.section
            likeBtn.setTitle(" Like (\(singleComment["likesNum"] as! String))", for: .normal)
            likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
            
            let replayBtn = comment.replayBtn!
            replayBtn.tag = indexPath.section
            replayBtn.addTarget(self, action: #selector(replayAction), for: .touchUpInside)
            
            return comment
        }else if replayFlag && indexPath.section == replaySection && indexPath.row == rowCount - 1 {
            let addReplay = tableView.dequeueReusableCell(withIdentifier: "addReplay", for: indexPath)
            
            addReplayTxt = addReplay.viewWithTag(1) as! UITextField
            addReplayTxt.layer.masksToBounds = true
            addReplayTxt.layer.cornerRadius = addReplayTxt.frame.height/2
            addReplayTxt.layer.borderWidth = 2
            if #available(iOS 13.0, *) {
                addReplayTxt.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
            }
            
            addReplayBtn = addReplay.viewWithTag(2) as! UIButton
            addReplayBtn.tag = indexPath.section
            addReplayBtn.addTarget(self, action: #selector(addReplayAction), for: .touchUpInside)
            
            return addReplay
        }else {
            let replay = tableView.dequeueReusableCell(withIdentifier: "replay", for: indexPath) as! replayTableViewCell
            
            let singleComment = comments[indexPath.section]
            let replays = singleComment["replayes"] as! [[String : Any]]
            let singleReplay = replays[indexPath.row - 1]
            let replayUploader = singleReplay["replayUploader"] as! [String : String]
            
            let userImageBtn = replay.userImageBtn!
            userImageBtn.sd_setBackgroundImage(with: URL(string: replayUploader["ProfileImagePath"]!), for: .normal, completed: nil)
            userImageBtn.layer.masksToBounds = true
            userImageBtn.layer.cornerRadius = userImageBtn.frame.height/2
            userImageBtn.layer.borderWidth = 2
            userImageBtn.layer.borderColor = UIColor.label.cgColor
            userImageBtn.tag = indexPath.row
            userImageBtn.accessibilityIdentifier = "\(indexPath.section)"
            userImageBtn.addTarget(self, action: #selector(replayUserNameImageAction), for: .touchUpInside)
            
            let userNameBtn = replay.userNameBtn!
            userNameBtn.setTitle(replayUploader["Name"]!, for: .normal)
            userNameBtn.tag = indexPath.row
            userNameBtn.accessibilityIdentifier = "\(indexPath.section)"
            userNameBtn.addTarget(self, action: #selector(replayUserNameImageAction), for: .touchUpInside)
            
            let commentLbl = replay.commentLbl!
            commentLbl.text! = singleReplay["content"] as! String
            
            let likeBtn = replay.likeBtn!
            if singleReplay["isLiked"] as! Bool {
                likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeBtn.tintColor = .red
            }else {
                likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                likeBtn.tintColor = .label
            }
            likeBtn.tag = indexPath.row
            likeBtn.setTitle(" Like (\(singleReplay["likesNum"] as! String))", for: .normal)
            likeBtn.accessibilityIdentifier = "\(indexPath.section)"
            likeBtn.addTarget(self, action: #selector(replayLikeAction), for: .touchUpInside)
            
            return replay
        }
    }
}

extension commentsViewController {
    @objc func refreshAction(_ sender: AnyObject){
        setupPostCommentsAPI()
    }
    
    @objc func userNameImageAction(button: UIButton) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let singleComment = comments[button.tag]
        let commentUploader = singleComment["commentUploader"] as! [String : String]
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        profileViewController.modalPresentationStyle = .fullScreen
        profileViewController.userId = commentUploader["_id"]!
        if commentUploader["_id"]! == userId {
            profileViewController.mineFlag = true
        }else{
            profileViewController.mineFlag = false
        }
        present(profileViewController, animated: true, completion: nil)
    }
    
    @objc func replayUserNameImageAction(button: UIButton) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let singleComment = comments[Int(button.accessibilityIdentifier!)!]
        let replays = singleComment["replayes"] as! [[String : Any]]
        let singleReplay = replays[button.tag - 1]
        let replayUploader = singleReplay["replayUploader"] as! [String : String]
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        profileViewController.modalPresentationStyle = .fullScreen
        profileViewController.userId = replayUploader["_id"]!
        if replayUploader["_id"]! == userId {
            profileViewController.mineFlag = true
        }else{
            profileViewController.mineFlag = false
        }
        present(profileViewController, animated: true, completion: nil)
    }
    
    @objc func likeAction(button: UIButton) {
        var singleComment = comments[button.tag]
        let commentId = singleComment["_id"] as! String
        let likesNum = singleComment["likesNum"] as! String
        
        if singleComment["isLiked"] as! Bool {
            
            singleComment.updateValue(false, forKey: "isLiked")
            singleComment.updateValue("\(Int(likesNum)! - 1)", forKey: "likesNum")
            
        }
        
        else {
            
            singleComment.updateValue(true, forKey: "isLiked")
            singleComment.updateValue("\(Int(likesNum)! + 1)", forKey: "likesNum")
            
        }
        
        comments.remove(at: button.tag)
        comments.insert(singleComment, at: button.tag)
                
        let section = IndexSet.init(integer: button.tag)
        tableView.reloadSections(section, with: .fade)
        
        setupCommentLikeAPI(commentId: commentId)
        
    }
    
    @objc func replayLikeAction(button: UIButton) {
        print(Int(button.accessibilityIdentifier!)!)
        var singleComment = comments[Int(button.accessibilityIdentifier!)!]
        var replays = singleComment["replayes"] as! [[String : Any]]
        var singleReplay = replays[button.tag - 1]
        let replayId = singleReplay["_id"] as! String
        let likesNum = singleReplay["likesNum"] as! String
        
        if singleReplay["isLiked"] as! Bool {
            
            singleReplay.updateValue(false, forKey: "isLiked")
            singleReplay.updateValue("\(Int(likesNum)! - 1)", forKey: "likesNum")
            
        }
        
        else {
            
            singleReplay.updateValue(true, forKey: "isLiked")
            singleReplay.updateValue("\(Int(likesNum)! + 1)", forKey: "likesNum")
            
        }
        
        replays.remove(at: button.tag - 1)
        replays.insert(singleReplay, at: button.tag - 1)
        
        singleComment["replayes"] = replays
        
        comments.remove(at: Int(button.accessibilityIdentifier!)!)
        comments.insert(singleComment, at: Int(button.accessibilityIdentifier!)!)
                
        let section = IndexSet.init(integer: Int(button.accessibilityIdentifier!)!)
        tableView.reloadSections(section, with: .fade)
        
        setupReplayLikeAPI(replayId: replayId)
        
    }
    
    @objc func replayAction(button: UIButton) {
        replaySection = button.tag
        if replayFlag {
            addReplayBtn.tag = 2
        }
        
        replayFlag = !replayFlag
        tableView.reloadData()
    }
    
    @objc func addReplayAction(button: UIButton) {
        if addReplayTxt.text! != "" {
            let singleComment = comments[button.tag]
            let commentId = singleComment["_id"] as! String
            
            setupReplayCommentAPI(commentId: commentId)
        }else {
            let alert = UIAlertController(title: "sorry", message: "You must write something in replay", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
