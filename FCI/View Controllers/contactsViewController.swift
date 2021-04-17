//
//  contactsViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/9/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class contactsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var contacts = [[String : Any]]()
    var unreadMessages = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        loading.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupContactsAPI()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension contactsViewController {
    func layouts() {
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = false
        searchBar.searchTextField.shouldResignOnTouchOutsideMode = .enabled
        
    }
    
    func setupContactsAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getContacts(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.contacts = responseValue["contacts"] as! [[String : Any]]
                    print(self.contacts)
                    
                    if self.contacts.count != 0 {
                        self.unreadMessages.removeAll()
                        var i = 0
                        for _ in self.contacts {
                            let singleContact = self.contacts[i]
                            let secondUserId = singleContact["_id"] as! String
                            self.setupUnreadMessagesBetween2UsersAPI(secondUserId: secondUserId)
                            
                            i += 1
                        }
                    }else {
                        self.loading.stopAnimating()
                        self.refreshControl.endRefreshing()
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
    
    func setupUnreadMessagesBetween2UsersAPI(secondUserId: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getUnreadMessagesBetween2Users(firstUserId: userId, secondUserId: secondUserId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    let unreadMsg = responseValue["unreadMessages"] as! Int
                    print(unreadMsg)
                    
                    self.unreadMessages.append(unreadMsg)
                    
                    if self.unreadMessages.count == self.contacts.count {
                        self.loading.stopAnimating()
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
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
    
    func setupContactsSearchAPI(searchWord: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["key" : searchWord, "userId" : userId]
        
        Alamofire.request(APIs.contactsSearch(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.contacts = responseValue["contacts"] as! [[String : Any]]
                    print(self.contacts)
                    
                    if self.contacts.count != 0 {
                        self.unreadMessages.removeAll()
                        var i = 0
                        for _ in self.contacts {
                            let singleContact = self.contacts[i]
                            let secondUserId = singleContact["_id"] as! String
                            self.setupUnreadMessagesBetween2UsersAPI(secondUserId: secondUserId)
                            
                            i += 1
                        }
                    }else {
                        self.loading.stopAnimating()
                        self.refreshControl.endRefreshing()
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

extension contactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loading.startAnimating()
        if searchText != "" {
            searchBar.setShowsCancelButton(true, animated: true)
            setupContactsSearchAPI(searchWord: searchText)
        }else {
            searchBar.setShowsCancelButton(false, animated: true)
            setupContactsAPI()
        }
            
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        searchBar.setShowsCancelButton(false, animated: true)
        setupContactsAPI()
    }
}

extension contactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)
        
        let singleContact = contacts[indexPath.row]
        let lastMessage = singleContact["lastMessage"] as! [String : String]
        
        let profilePicture = contact.viewWithTag(1) as! UIImageView
        if singleContact["ProfileImagePath"] != nil {
            profilePicture.sd_setImage(with: URL(string: singleContact["ProfileImagePath"] as! String), completed: nil)
        }else {
            profilePicture.image = UIImage(named: "login user")
        }
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.label.cgColor
        
        let userNameLbl = contact.viewWithTag(2) as! UILabel
        if singleContact["title"] != nil {
            userNameLbl.text! = "\(singleContact["title"]!) \(singleContact["Name"]!)"
        }else {
            userNameLbl.text! = singleContact["Name"] as! String
        }
        
        let lastMessageLbl = contact.viewWithTag(3) as! UILabel
        lastMessageLbl.text! = lastMessage["content"]!
        
        let unreadNumLbl = contact.viewWithTag(4) as! UILabel
        if unreadMessages[indexPath.row] == 0 {
            unreadNumLbl.isHidden = true
        }else{
            unreadNumLbl.isHidden = false
            unreadNumLbl.text! = "\(unreadMessages[indexPath.row])"
            unreadNumLbl.layer.masksToBounds = true
            unreadNumLbl.layer.cornerRadius = unreadNumLbl.frame.height/2
        }
        
        return contact
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let singleContact = contacts[indexPath.row]
        
        let chatViewController = storyboard?.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
        chatViewController.modalPresentationStyle = .fullScreen
        chatViewController.secondUserId = singleContact["_id"] as! String
        chatViewController.userImg = singleContact["ProfileImagePath"] as! String
        if singleContact["title"] != nil {
            chatViewController.userName = "\(singleContact["title"]!) \(singleContact["Name"]!)"
        }else {
            chatViewController.userName = singleContact["Name"] as! String
        }
        present(chatViewController, animated: true, completion: nil)
        
    }
}

extension contactsViewController {
    @objc func refreshAction(_ sender: AnyObject){
        loading.startAnimating()
        setupContactsAPI()
    }
}
