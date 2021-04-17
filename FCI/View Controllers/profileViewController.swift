//
//  profileViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 7/31/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class profileViewController: UIViewController {

    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var userNameView: UIStackView!
    @IBOutlet weak var aboutTxt: UITextField!
    @IBOutlet weak var aboutView: UIStackView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var emailView: UIStackView!
    @IBOutlet weak var levelTxt: UITextField!
    @IBOutlet weak var levelView: UIStackView!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var cityView: UIStackView!
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var genderView: UIStackView!
    @IBOutlet weak var currentPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var passwordView: UIStackView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var editPicBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var messageBtn: UIButton!
    
    var userInfo = [String : String]()
    var userId = String()
    var mineFlag = Bool()
    var editPicFlag = false
    var editPasswordFlag = false
    var imageUrl: URL!
    var fileExtension = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
        loading.startAnimating()
        setupUserInfoAPI()
        
    }

    @IBAction func messageAction(_ sender: Any) {
        let chatViewController = storyboard?.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
        chatViewController.modalPresentationStyle = .fullScreen
        chatViewController.secondUserId = userInfo["_id"]!
        chatViewController.userImg = userInfo["ProfileImagePath"]!
        if userInfo["title"] != nil {
            chatViewController.userName = "\(userInfo["title"]!) \(userInfo["Name"]!)"
        }else {
            chatViewController.userName = userInfo["Name"]!
        }
        present(chatViewController, animated: true, completion: nil)
    }
    
    @IBAction func editPicAction(_ sender: Any) {
        pickImage()
    }
    
    @IBAction func editPasswordAction(_ sender: Any) {
        if !editPicFlag {
            if editPasswordFlag {
                saveBtn.isEnabled = false
                saveBtn.alpha = 0.5
            }else{
                saveBtn.isEnabled = true
                saveBtn.alpha = 1
            }
            
            editPasswordFlag = !editPasswordFlag
        }
        
        currentPasswordTxt.isHidden = !currentPasswordTxt.isHidden
        newPasswordTxt.isHidden = !newPasswordTxt.isHidden
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveBtn.isEnabled = false
        saveBtn.alpha = 0.5
        
        if !currentPasswordTxt.isHidden && !newPasswordTxt.isHidden {
            if currentPasswordTxt.text! != "" && newPasswordTxt.text! != "" {
                
                if !self.editPicFlag {
                    loading.startAnimating()
                }
                setupUpdatePasswordAPI()
            }else {
                
                let alert = UIAlertController(title: "sorry", message: "Please enter current password then new password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
            }
        }
        
        if editPicFlag {
            setupupdateProfileImageAPI()
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension profileViewController {
    func layouts(){
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            profilePicture.layer.borderColor = UIColor.label.cgColor
        }
        
        if #available(iOS 13.0, *) {
            userNameTxt.layer.borderColor = UIColor.label.cgColor
        }
        userNameTxt.layer.borderWidth = 2
        userNameTxt.rightViewMode = .always
        userNameTxt.layer.masksToBounds = true
        userNameTxt.layer.cornerRadius = userNameTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            aboutTxt.layer.borderColor = UIColor.label.cgColor
        }
        aboutTxt.layer.borderWidth = 2
        aboutTxt.rightViewMode = .always
        aboutTxt.layer.masksToBounds = true
        aboutTxt.layer.cornerRadius = aboutTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            emailTxt.layer.borderColor = UIColor.label.cgColor
        }
        emailTxt.layer.borderWidth = 2
        emailTxt.rightViewMode = .always
        emailTxt.layer.masksToBounds = true
        emailTxt.layer.cornerRadius = emailTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            levelTxt.layer.borderColor = UIColor.label.cgColor
        }
        levelTxt.layer.borderWidth = 2
        levelTxt.rightViewMode = .always
        levelTxt.layer.masksToBounds = true
        levelTxt.layer.cornerRadius = levelTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            cityTxt.layer.borderColor = UIColor.label.cgColor
        }
        cityTxt.layer.borderWidth = 2
        cityTxt.rightViewMode = .always
        cityTxt.layer.masksToBounds = true
        cityTxt.layer.cornerRadius = cityTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            genderTxt.layer.borderColor = UIColor.label.cgColor
        }
        genderTxt.layer.borderWidth = 2
        genderTxt.rightViewMode = .always
        genderTxt.layer.masksToBounds = true
        genderTxt.layer.cornerRadius = genderTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            currentPasswordTxt.layer.borderColor = UIColor.label.cgColor
        }
        currentPasswordTxt.layer.borderWidth = 2
        currentPasswordTxt.rightViewMode = .always
        currentPasswordTxt.layer.masksToBounds = true
        currentPasswordTxt.layer.cornerRadius = currentPasswordTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            newPasswordTxt.layer.borderColor = UIColor.label.cgColor
        }
        newPasswordTxt.layer.borderWidth = 2
        newPasswordTxt.rightViewMode = .always
        newPasswordTxt.layer.masksToBounds = true
        newPasswordTxt.layer.cornerRadius = newPasswordTxt.frame.height/2
        
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = saveBtn.frame.height/2
        
        messageBtn.layer.masksToBounds = true
        messageBtn.layer.cornerRadius = messageBtn.frame.height/2
    }
    
    func setData() {
        if mineFlag {
            editPicBtn.isHidden = false
            let tapGestur = UITapGestureRecognizer(target: self, action: #selector(editPicAction))
            profilePicture.addGestureRecognizer(tapGestur)
            profilePictureView.addGestureRecognizer(tapGestur)
            
            passwordView.isHidden = false
            saveBtn.isHidden = false
        }else {
            messageBtn.isHidden = false
        }
        
        if userInfo["ProfileImagePath"] != nil {
            profilePicture.sd_setImage(with: URL(string: userInfo["ProfileImagePath"]!), completed: nil)
        }else{
            profilePicture.image = UIImage(named: "login user")
        }
        
        if userInfo["Name"] != nil {
            userNameView.isHidden = false

            if userInfo["title"] != nil {
                userNameTxt.text! = "\(userInfo["title"]!) \(userInfo["Name"]!)"
            }else {
                userNameTxt.text! = userInfo["Name"]!
            }
            
        }
        
        if userInfo["bio"] != nil {
            aboutView.isHidden = false
            aboutTxt.text! = userInfo["bio"]!
        }
        
        if userInfo["Email"] != nil {
            emailView.isHidden = false
            emailTxt.text! = userInfo["Email"]!
        }
        
        if userInfo["level"] != nil {
            levelView.isHidden = false
            switch userInfo["level"]! {
            case "1":
                levelTxt.text! = "First Grade"
            case "2":
                levelTxt.text! = "Second Grade"
            case "3cs":
                levelTxt.text! = "Third Grade (CS)"
            case "3is":
                levelTxt.text! = "Third Grade (IS)"
            case "4cs":
                levelTxt.text! = "Fourth Grade (CS)"
            case "4is":
                levelTxt.text! = "Fourth Grade (IS)"
            default:
                levelTxt.text! = "General"
            }
        }
        
        if userInfo["city"] != nil {
            cityView.isHidden = false
            cityTxt.text! = userInfo["city"]!
        }
        
        if userInfo["Gender"] != nil {
            genderView.isHidden = false
            genderTxt.text! = userInfo["Gender"]!
        }
    }
    
    func setupUserInfoAPI() {
        Alamofire.request(APIs.getUserInfo(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.userInfo = responseValue["user"] as! [String : String]
                    self.setData()
                    self.loading.stopAnimating()
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
    
    func setupupdateProfileImageAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["userId" : userId]
        
        var mediaData = Data()
        do {
            mediaData = try Data(contentsOf: imageUrl!, options: .mappedIfSafe)
            
        }catch {}
               
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
                   
            MultipartFormData.append(mediaData, withName: "file", fileName: "profileImage.\(self.fileExtension)", mimeType: "image/\(self.fileExtension)")
                   
            for (key, value) in parameter {
                       
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                       
            }
                   
        }, usingThreshold: UInt64.init() , to: APIs.updateProfileImage() , method: .post) { (result) in
                   
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
                            
                            self.fileExtension = ""
                            self.currentPasswordTxt.text! = ""
                            self.newPasswordTxt.text! = ""
                            self.currentPasswordTxt.isHidden = true
                            self.newPasswordTxt.isHidden = true
                            
                            let alert = UIAlertController(title: "Done", message: (responseValue["message"] as! String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
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
    
    func setupUpdatePasswordAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["oldPassword" : currentPasswordTxt.text!, "newPassword" : newPasswordTxt.text!, "userId" : userId]
        
        Alamofire.request(APIs.updatePassword(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    if !self.editPicFlag {
                        self.loading.stopAnimating()
                        
                        self.currentPasswordTxt.text! = ""
                        self.newPasswordTxt.text! = ""
                        self.currentPasswordTxt.isHidden = true
                        self.newPasswordTxt.isHidden = true
                    }
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

extension profileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.showsCameraControls = true
                
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
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            else{
                
                let alert = UIAlertController(title: "sorry", message: "please give us a permission to access photos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { action in
            
            self.profilePicture.image = UIImage(named: "login user")
            self.fileExtension = ""
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        editPicFlag = true
        saveBtn.isEnabled = true
        saveBtn.alpha = 1
        
        let image = info[.editedImage] as! UIImage
        imageUrl = info[.imageURL] as? URL
        fileExtension = imageUrl.pathExtension
        profilePicture.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
