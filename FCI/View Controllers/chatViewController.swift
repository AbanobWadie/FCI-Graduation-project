//
//  chatViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/9/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire
import SDWebImage

class chatViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var typeStateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTxt: UITextField!
    
    var messages = [[String : Any]]()
    var secondUserId = String()
    var userImg = String()
    var userName = String()
    var timer = Timer()
    let manager = SocketManager(socketURL: URL(string: "https://fciapi.herokuapp.com")!, config: [.log(false), .forceWebsockets(true)])
    var socket: SocketIOClient!
    var fileUrl: URL!
    var fileExtension = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = manager.defaultSocket
        socket.connect()
        
        layouts()
        setData()
        setupSocketIO()
        
        messageTxt.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        setupMessagesBetween2UsersAPI()
        setupAssignMessagesAsReadedAPI()
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        socket.disconnect()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        if messageTxt.text! != "" {
            setupSendTextMessageAPI()
        }else {
            let alert = UIAlertController(title: "sorry", message: "You must write message first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendPicAction(_ sender: Any) {
        pickImage()
    }
}

extension chatViewController {
    func layouts() {
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.label.cgColor
        
        messageTxt.layer.masksToBounds = true
        messageTxt.layer.cornerRadius = messageTxt.frame.height/2
        messageTxt.layer.borderWidth = 2
        messageTxt.layer.borderColor = UIColor.label.cgColor
    }
    
    func setupSocketIO() {
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
            print("connected")
        }
        
        socket.on("newMessage") { (data, _) in
            print(data)
            print("newMessage")
            
            let newMessage = data[0] as! [String : Any]
            let userId = UserDefaults.standard.string(forKey: "userId")!
            
            if newMessage["reciver"] as! String == userId || newMessage["sender"] as! String == userId {
                self.messages = self.messages.reversed()
                self.messages.append(newMessage)
                self.messages = self.messages.reversed()
                self.tableView.reloadData()
                self.setupAssignMessagesAsReadedAPI()
            }
        }
        
        socket.on("userTyping") { (data, act) in
            print(data)
            print("userTyping")
            
            let typing = data[0] as! [String : String]
            let userId = UserDefaults.standard.string(forKey: "userId")!
            
            if typing["reciver"]! == userId || typing["sender"]! == userId {
                self.typeStateLbl.isHidden = false
            }
        }
    }
    
    func setData() {
        userImage.sd_setImage(with: URL(string: userImg), completed: nil)
        userNameLbl.text! = userName
    }
    
    func setupMessagesBetween2UsersAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getMesagesBetween2Users(firstUserId: userId, secondUserId: secondUserId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    let msgs = responseValue["messages"] as! [[String : Any]]
                    self.messages = msgs.reversed()
                    print(self.messages)
                    
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
    
    func setupAssignMessagesAsReadedAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.assignMesagesAsReaded(firstUserId: userId, secondUserId: secondUserId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    
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
    
    func setupSendTextMessageAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!

        let parameter = ["reciverId" : secondUserId, "senderId" : userId, "message" : messageTxt.text!, "messageType" : "text"]
        
        Alamofire.request(APIs.sendMessage(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.messageTxt.text! = ""
                    self.fileUrl = nil
                    self.fileExtension = ""
                    
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
    
    func setupSendImageMessageAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["reciverId" : secondUserId, "senderId" : userId, "message" : messageTxt.text!, "messageType" : "image"]
        
        var mediaData = Data()
        do {
            mediaData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            
        }catch {}
               
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
                   
            MultipartFormData.append(mediaData, withName: "files", fileName: "image.\(self.fileExtension)", mimeType: "image/\(self.fileExtension)")
                   
            for (key, value) in parameter {
                
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                       
            }
                   
        }, usingThreshold: UInt64.init() , to: APIs.sendMessage() , method: .post) { (result) in
                   
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                    print(progress.fractionCompleted)
                           
                    //self.progressView.isHidden = false
                    //self.progressView.progress = Float(progress.fractionCompleted)
                }
                       
                upload.responseJSON { (response) in
                    if response.response?.statusCode == 200 {
                        let responseValue = response.result.value as! [String : Any]
                        if responseValue["success"] as! Bool {
                            //self.progressView.isHidden = true
                            
                           self.messageTxt.text! = ""
                           self.fileUrl = nil
                           self.fileExtension = ""
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
}

extension chatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let singleMessage = messages[indexPath.section]
        
        if singleMessage["reciver"] as! String == userId {
            let sender = tableView.dequeueReusableCell(withIdentifier: "sender", for: indexPath) as! senderTableViewCell
            sender.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            let senderView = sender.senderView!
            senderView.layer.masksToBounds = true
            senderView.layer.cornerRadius = senderView.frame.height/12
            
            let imageMessage = sender.imageMessage!
            let textMessageLbl = sender.textMessageLbl!
            if singleMessage["messageType"] as! String == "text" {
                imageMessage.isHidden = true
                textMessageLbl.isHidden = false
                textMessageLbl.text! = singleMessage["content"] as! String
            }else if singleMessage["messageType"] as! String == "image" {
                let images = singleMessage["images"] as! [String]
                imageMessage.isHidden = false
                textMessageLbl.isHidden = true
                imageMessage.sd_setImage(with: URL(string: images[0]), completed: nil)
            }else {
                imageMessage.isHidden = true
                textMessageLbl.isHidden = false
                textMessageLbl.text! = "▶︎ Voice Note"
            }
            
            let dateTimeLbl = sender.dateTimeLbl!
            dateTimeLbl.text! = singleMessage["timestemp"] as! String
            
            return sender
        }else {
            let reciever = tableView.dequeueReusableCell(withIdentifier: "reciever", for: indexPath) as! recieverTableViewCell
            reciever.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            let recieverView = reciever.recieverView!
            recieverView.layer.masksToBounds = true
            recieverView.layer.cornerRadius = recieverView.frame.height/12
            
            if singleMessage["messageType"] as! String == "text" {
                let textMessageLbl = reciever.textMessageLbl!
                textMessageLbl.isHidden = false
                textMessageLbl.text! = singleMessage["content"] as! String
            }else {
                let images = singleMessage["images"] as! [String]
                let imageMessage = reciever.imageMessage!
                imageMessage.isHidden = false
                imageMessage.sd_setImage(with: URL(string: images[0]), completed: nil)
            }
            
            let dateTimeLbl = reciever.dateTimeLbl!
            dateTimeLbl.text! = singleMessage["timestemp"] as! String
            
            return reciever
        }
    }
}

extension chatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let data = ["sender" : userId, "reciver" : secondUserId]
        
        socket.emit("typing", with: [data])
    }
}

extension chatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.showsCameraControls = true
                imagePicker.mediaTypes = ["public.image"]
                    
                
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
                imagePicker.mediaTypes = ["public.image"]
                
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
        
        if info[.imageURL] != nil {
            let imageUrl = info[.imageURL] as! URL
            fileUrl = imageUrl
            fileExtension = imageUrl.pathExtension
        }
        picker.dismiss(animated: true, completion: nil)
        setupSendImageMessageAPI()
    }
}


extension chatViewController {
    @objc func timerAction() {
        typeStateLbl.isHidden = true
    }
}
