//
//  homeViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 7/28/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import AVKit
import MobileCoreServices

class homeViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    
    
    var level = String()
    var posts = [[String : Any]]()
    var videoLinks = [String : String]()
    var refreshControl = UIRefreshControl()
    var postTxt = UITextField()
    var progressView = UIProgressView()
    var uploadBtn = UIButton()
    var fileUrl:URL!
    var fileType = String()
    var fileExtension = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuWidth.constant = (view.frame.width/3)*2
        tableView.delegate = self
        tableView.dataSource = self
        
        setupPostsByLevelAPI()
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func menuAction(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden
        
        if menuView.isHidden {
            tableView.alpha = 1
            tableView.isUserInteractionEnabled = true
        }else{
            tableView.alpha = 0.5
            tableView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "searchViewController") as! searchViewController
        searchViewController.modalPresentationStyle = .fullScreen
        present(searchViewController, animated: true, completion: nil)
    }
}

extension homeViewController {
    func setupPostsByLevelAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        switch level {
        case "1":
            titleLbl.text! = "First Grade"
        case "2":
            titleLbl.text! = "Second Grade"
        case "3cs":
            titleLbl.text! = "Third Grade (CS)"
        case "3is":
            titleLbl.text! = "Third Grade (IS)"
        case "4cs":
            titleLbl.text! = "Fourth Grade (CS)"
        case "4is":
            titleLbl.text! = "Fourth Grade (IS)"
        default:
            titleLbl.text! = "General"
        }
        
        Alamofire.request(APIs.postsByLevel(userId: userId, level: level), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.posts = responseValue["posts"] as! [[String : Any]]
                    print(self.posts)
                    
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
    
    func setupCreatePostByLevelAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["postContent" : postTxt.text!, "userId" : userId, "level" : level]
        
        var mediaData = Data()
        var fileName = String()
        var mimeType = String()
            
        if fileUrl != nil {
            do {
                mediaData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                if fileType == "image" {
                    fileName = "image.\(self.fileExtension)"
                    mimeType = "image/\(self.fileExtension)"
                }else if fileType == "video" {
                    fileName = "video.\(self.fileExtension)"
                    mimeType = "video/\(self.fileExtension)"
                }else {
                    fileName = "file.\(self.fileExtension)"
                    mimeType = "file/\(self.fileExtension)"
                }
            }catch {}
        }
               
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
                   
            MultipartFormData.append(mediaData, withName: "file", fileName: fileName, mimeType: mimeType)
                   
            for (key, value) in parameter {
                       
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                       
            }
                   
        }, usingThreshold: UInt64.init() , to: APIs.createPostByLevel() , method: .post) { (result) in
                   
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                    print(progress.fractionCompleted)
                           
                    self.progressView.isHidden = false
                    self.progressView.progress = Float(progress.fractionCompleted)
                }
                       
                upload.responseJSON { (response) in
                    if response.response?.statusCode == 200 {
                        let responseValue = response.result.value as! [String : Any]
                        if responseValue["success"] as! Bool {
                            self.progressView.isHidden = true
                            
                            let alert = UIAlertController(title: "Done", message: (responseValue["message"] as! String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.fileUrl = nil
                            self.fileType = ""
                            self.fileExtension = ""
                            self.uploadBtn.setTitle("", for: .normal)
                            self.postTxt.text! = ""
                            self.tableView.reloadData()
                        }else {
                            let alert = UIAlertController(title: "sorry", message: (responseValue["message"] as! String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                       
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupLikeAPI(postId: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["postId" : postId, "userId" : userId]
        
        Alamofire.request(APIs.like(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
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

extension homeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let create = tableView.dequeueReusableCell(withIdentifier: "create", for: indexPath)
                
                postTxt = create.viewWithTag(1) as! UITextField
                
                return create
            }else {
                let createBtns = tableView.dequeueReusableCell(withIdentifier: "createBtns", for: indexPath)
                
                uploadBtn = createBtns.viewWithTag(1) as! UIButton
                uploadBtn.addTarget(self, action: #selector(uploadAction), for: .touchUpInside)
                
                let postBtn = createBtns.viewWithTag(2) as! UIButton
                postBtn.addTarget(self, action: #selector(postAction), for: .touchUpInside)
                
                progressView = createBtns.viewWithTag(3) as! UIProgressView
                
                return createBtns
            }
        }else {
            if indexPath.row == 0 {
                let post = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! postTableViewCell
                
                let singlePost = posts[indexPath.section-1]
                let postCreator = singlePost["postUploader"] as! [String : String]
                
                let userImageBtn = post.userImageBtn!
                userImageBtn.sd_setBackgroundImage(with: URL(string: postCreator["ProfileImagePath"]!), for: .normal, completed: nil)
                userImageBtn.layer.masksToBounds = true
                userImageBtn.layer.cornerRadius = userImageBtn.frame.height/2
                userImageBtn.layer.borderWidth = 2
                userImageBtn.layer.borderColor = UIColor.label.cgColor
                userImageBtn.tag = indexPath.section
                userImageBtn.addTarget(self, action: #selector(userNameImageAction), for: .touchUpInside)
                
                let userNameBtn = post.userNameBtn!
                userNameBtn.setTitle(postCreator["Name"]!, for: .normal)
                userNameBtn.tag = indexPath.section
                userNameBtn.addTarget(self, action: #selector(userNameImageAction), for: .touchUpInside)
                
                let userEmailLbl = post.userEmailLbl!
                userEmailLbl.text! = postCreator["Email"]!
                
                let postDateTimeLbl = post.postDateTimeLbl!
                postDateTimeLbl.text! = singlePost["timestemp"] as! String
                
                let postContentLbl = post.postContentLbl!
                postContentLbl.text! = singlePost["content"] as! String
                
                let attachmentsLinkBtn = post.attachmentsLinkBtn!
                attachmentsLinkBtn.tag = indexPath.section
                attachmentsLinkBtn.addTarget(self, action: #selector(attachmentsLinkAction), for: .touchUpInside)
                
                let postImageView = post.postImageView!
                let videoView = post.videoView!
                                
                if singlePost["filePath"] != nil && singlePost["postType"] != nil && singlePost["postType"] as AnyObject? !== NSNull() {
                    let filePath = singlePost["filePath"] as! String
                    let postType = singlePost["postType"] as! String
                    
                    if filePath != "" {
                        switch postType {
                        case "image/png":
                            postImageView.isHidden = false
                            videoView.isHidden = true
                            attachmentsLinkBtn.isHidden = true
                            postImageView.sd_setImage(with: URL(string: filePath), completed: nil)
                        case "image/jpeg":
                            postImageView.isHidden = false
                            videoView.isHidden = true
                            attachmentsLinkBtn.isHidden = true
                            postImageView.sd_setImage(with: URL(string: filePath), completed: nil)
                        case "video/mp4":
                            postImageView.isHidden = true
                            videoView.isHidden = false
                            attachmentsLinkBtn.isHidden = true
                            videoLinks["\(indexPath.section)"] = filePath
                        case "none":
                            attachmentsLinkBtn.isHidden = true
                            postImageView.isHidden = true
                            videoView.isHidden = true
                        default:
                            postImageView.isHidden = true
                            videoView.isHidden = true
                            attachmentsLinkBtn.isHidden = false
                            attachmentsLinkBtn.setTitle(filePath, for: .normal)
                        }
                    }else{
                        attachmentsLinkBtn.isHidden = true
                        postImageView.isHidden = true
                        videoView.isHidden = true
                    }
                    
                }else {
                    attachmentsLinkBtn.isHidden = true
                    postImageView.isHidden = true
                    videoView.isHidden = true
                }
                
                let videoBtn = post.videoBtn!
                videoBtn.tag = indexPath.section
                videoBtn.addTarget(self, action: #selector(videoAction), for: .touchUpInside)
                
                let likesNumLbl = post.likesNumLbl!
                likesNumLbl.text! = "♥  " + (singlePost["likesNum"] as! String)
                
                let commentsNumLbl = post.commentsNumLbl!
                commentsNumLbl.text! = (singlePost["commentsNum"] as! String) + " Comments"
                
                return post
            }else {
                let reacting = tableView.dequeueReusableCell(withIdentifier: "reacting", for: indexPath) as! reactingTableViewCell
                
                let singlePost = posts[indexPath.section-1]
                
                let likeBtn = reacting.likeBtn!
                if singlePost["isLiked"] as! Bool {
                    likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    likeBtn.tintColor = .red
                }else {
                    likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                    likeBtn.tintColor = .label
                }
                likeBtn.tag = indexPath.section
                likeBtn.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
                
                let commentBtn = reacting.commentBtn!
                commentBtn.tag = indexPath.section
                commentBtn.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
                
                return reacting
            }
        }
    }
}

extension homeViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func pickDocument() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeText), String(kUTTypeItem)], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .fullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentUrl = urls.first else {
            return
        }
        print("file url : \(documentUrl)")
        
        uploadBtn.setTitle("(Document)", for: .normal)
        fileUrl = documentUrl
        fileType = "document"
        fileExtension = documentUrl.pathExtension
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension homeViewController: UIImagePickerControllerDelegate {
    func pickImageOrVideo() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.showsCameraControls = true
                imagePicker.mediaTypes = ["public.image", "public.movie"]
                    
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            else{
                
                let alert = UIAlertController(title: "sorry", message: "please give us a permission to access camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Open Photo Library", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = ["public.image", "public.movie"]
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            else{
                
                let alert = UIAlertController(title: "sorry", message: "please give us a permission to access photos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //image picker data source
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //photo selection
        if info[.imageURL] != nil {
            let imageUrl = info[.imageURL] as! URL
            uploadBtn.setTitle("(Image)", for: .normal)
            fileUrl = imageUrl
            fileType = "image"
            fileExtension = imageUrl.pathExtension
        }
        
        //video selection
        else if info[.mediaURL] != nil {
            let videoUrl = info[.mediaURL] as! URL
            uploadBtn.setTitle("(Video)", for: .normal)
            fileUrl = videoUrl
            fileType = "video"
            fileExtension = videoUrl.pathExtension
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension homeViewController {
    @objc func refreshAction(_ sender: AnyObject){
        setupPostsByLevelAPI()
        
        postTxt.text! = ""
        self.fileUrl = nil
        self.fileType = ""
        self.fileExtension = ""
        self.uploadBtn.setTitle("", for: .normal)
    }
    
    @objc func uploadAction() {
        if fileUrl != nil {
            let options = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
            options.addAction(UIAlertAction(title: "Change Photo or Video", style: .default, handler: { (action) in
                self.pickImageOrVideo()
            }))
            options.addAction(UIAlertAction(title: "Change Document", style: .default, handler: { (action) in
                self.pickDocument()
            }))
            options.addAction(UIAlertAction(title: "Remove Attached File", style: .destructive, handler: { (action) in
                self.fileUrl = nil
                self.fileType = ""
                self.fileExtension = ""
                self.uploadBtn.setTitle("", for: .normal)
            }))
            options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(options, animated: true, completion: nil)
        }else{
            let options = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
            options.addAction(UIAlertAction(title: "Add Photo or Video", style: .default, handler: { (action) in
                self.pickImageOrVideo()
            }))
            options.addAction(UIAlertAction(title: "Add Document", style: .default, handler: { (action) in
                self.pickDocument()
            }))
            options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(options, animated: true, completion: nil)
        }
    }
    
    @objc func postAction() {
        if postTxt.text! != "" {
            setupCreatePostByLevelAPI()
        }else{
            let alert = UIAlertController(title: "sorry", message: "You must write something in post content", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func userNameImageAction(button: UIButton) {
        let singlePost = posts[button.tag - 1]
        let postCreator = singlePost["postUploader"] as! [String : String]
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        profileViewController.modalPresentationStyle = .fullScreen
        profileViewController.userId = postCreator["_id"]!
        profileViewController.mineFlag = singlePost["mine"] as! Bool
        present(profileViewController, animated: true, completion: nil)
    }
    
    @objc func attachmentsLinkAction(button: UIButton) {
        let link = (button.titleLabel?.text)!
        
        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
    }
    
    @objc func videoAction(button: UIButton) {
        let link = videoLinks["\(button.tag)"]
        
        let url = URL(string: link!)
        let playerItem = AVPlayerItem(url: url!)
        let player = AVPlayer(playerItem: playerItem)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        present(playerVC, animated: true) {
            playerVC.player!.play()
        }
    }
    
    @objc func likeAction(button: UIButton) {
        var singlePost = posts[button.tag-1]
        let postId = singlePost["_id"] as! String
        let likesNum = singlePost["likesNum"] as! String
        
        if singlePost["isLiked"] as! Bool {
            
            singlePost.updateValue(false, forKey: "isLiked")
            singlePost.updateValue("\(Int(likesNum)! - 1)", forKey: "likesNum")
            
        }
        
        else {
            
            singlePost.updateValue(true, forKey: "isLiked")
            singlePost.updateValue("\(Int(likesNum)! + 1)", forKey: "likesNum")
            
        }
        
        posts.remove(at: button.tag-1)
        posts.insert(singlePost, at: button.tag-1)
                
        let section = IndexSet.init(integer: button.tag)
        self.tableView.reloadSections(section, with: .fade)
        
        setupLikeAPI(postId: postId)
        
    }
    
    @objc func commentAction(button: UIButton) {
        let singlePost = posts[button.tag-1]
        let postId = singlePost["_id"] as! String
        
        let commentsViewController = storyboard?.instantiateViewController(withIdentifier: "commentsViewController") as! commentsViewController
        commentsViewController.postId = postId
        present(commentsViewController, animated: true, completion: nil)
    }
}
