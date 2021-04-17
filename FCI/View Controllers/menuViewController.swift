//
//  menuViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/4/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class menuViewController: UIViewController {

    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userNameBtn: UIButton!
    @IBOutlet weak var unreadMessagesLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUserInfoAPI()
        setupTotalUnreadMessagesAPI()
    }
    
    @IBAction func userProfileAction(_ sender: Any) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        profileViewController.modalPresentationStyle = .fullScreen
        profileViewController.userId = userId
        profileViewController.mineFlag = true
        present(profileViewController, animated: true, completion: nil)
    }
    
    @IBAction func messagesAction(_ sender: Any) {
        let contactsViewController = storyboard?.instantiateViewController(withIdentifier: "contactsViewController") as! contactsViewController
        contactsViewController.modalPresentationStyle = .fullScreen
        present(contactsViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func matrialsAction(_ sender: Any) {
        let materialsViewController = self.storyboard?.instantiateViewController(withIdentifier: "materialsViewController") as! materialsViewController
        materialsViewController.modalPresentationStyle = .fullScreen
        present(materialsViewController, animated: true, completion: nil)
    }
   
    @IBAction func onlineQuizAction(_ sender: Any) {
        let quizViewController = storyboard?.instantiateViewController(withIdentifier: "quizViewController") as! quizViewController
        quizViewController.modalPresentationStyle = .fullScreen
        quizViewController.DismissFlag = false
        present(quizViewController, animated: true, completion: nil)
    }
    
    @IBAction func eventsAction(_ sender: Any) {
        let eventsViewController = storyboard?.instantiateViewController(withIdentifier: "eventsViewController") as! eventsViewController
        eventsViewController.modalPresentationStyle = .fullScreen
        present(eventsViewController, animated: true, completion: nil)
    }
     
    @IBAction func firstGradeAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.level = "1"
        present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func secondGradeAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.level = "2"
        present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func thirdGradeCSAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.level = "3cs"
        present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func thirdGradeISAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.level = "3is"
        present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func fourthGradeCSAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.level = "4cs"
        present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func fourthGradeISAction(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        homeViewController.modalPresentationStyle = .fullScreen
        homeViewController.level = "4is"
        present(homeViewController, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userType")
        UserDefaults.standard.removeObject(forKey: "level")
        
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
}

extension menuViewController {
    func layouts() {
        userImageBtn.layer.masksToBounds = true
        userImageBtn.layer.cornerRadius = userImageBtn.frame.height/2
        userImageBtn.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            userImageBtn.layer.borderColor = UIColor.label.cgColor
        }
        
        unreadMessagesLbl.layer.masksToBounds = true
        unreadMessagesLbl.layer.cornerRadius = unreadMessagesLbl.frame.height/2
    }
    
    func setupUserInfoAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getUserInfo(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    let userInfo = responseValue["user"] as! [String : String]
                    
                    if userInfo["ProfileImagePath"] != nil {
                        self.userImageBtn.sd_setImage(with: URL(string: userInfo["ProfileImagePath"]!), for: .normal, completed: nil)
                    }else{
                        self.userImageBtn.setImage(UIImage(named: "login user"), for: .normal)
                    }
                    
                    if userInfo["Name"] != nil {
                        if userInfo["title"] != nil {
                            self.userNameBtn.setTitle("\(userInfo["title"]!) \(userInfo["Name"]!)", for: .normal)
                        }else {
                            self.userNameBtn.setTitle(userInfo["Name"]!, for: .normal)
                            
                        }
                    }
                    
                    
                    
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
    
    func setupTotalUnreadMessagesAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getTotalUnreadMessages(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    if responseValue["unreadMessages"] as! Int == 0 {
                        self.unreadMessagesLbl.isHidden = true
                    }else {
                        self.unreadMessagesLbl.isHidden = false
                        self.unreadMessagesLbl.text! = "\(responseValue["unreadMessages"] as! Int)"
                    }
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
}
