//
//  searchViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/9/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import IQKeyboardManagerSwift

class searchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var optionSegmentedControl: UISegmentedControl!
    
    var refreshControl = UIRefreshControl()
    var users = [[String : Any]]()
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
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            setupStudentsByStudentAPI()
        }else{
            setupStudentsByDoctorAPI()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func optionSelector(_ sender: Any) {
        loading.startAnimating()
        if optionSegmentedControl.selectedSegmentIndex == 0 {
            if UserDefaults.standard.string(forKey: "userType")! == "Student" {
                setupStudentsByStudentAPI()
            }else{
                setupStudentsByDoctorAPI()
            }
        }else{
            setupDoctorsAPI()
        }
    }
    

}

extension searchViewController {
    func layouts() {
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBar.showsCancelButton = false
        searchBar.searchTextField.shouldResignOnTouchOutsideMode = .enabled
        
    }
    
    func setupStudentsByStudentAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getAllStudentsByStudent(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.users = responseValue["students"] as! [[String : Any]]
                    print(self.users)
                    
                    self.loading.stopAnimating()
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
    
    func setupStudentsByDoctorAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getAllStudentsByDoctor(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.users = responseValue["students"] as! [[String : Any]]
                    print(self.users)
                    
                    self.loading.stopAnimating()
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
    
    func setupDoctorsAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getDoctors(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.users = responseValue["doctors"] as! [[String : Any]]
                    print(self.users)
                    
                    self.loading.stopAnimating()
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
    
    func setupDoctorsSearchAPI(searchWord: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["searchKey" : searchWord, "userId" : userId]
        
        Alamofire.request(APIs.doctorsSearch(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.users = responseValue["doctors"] as! [[String : Any]]
                    print(self.users)
                    
                    self.loading.stopAnimating()
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
    
    func setupStudentsSearchByStudentAPI(searchWord: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["searchKey" : searchWord, "studentId" : userId]
        
        Alamofire.request(APIs.studentsSearchByStudent(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.users = responseValue["students"] as! [[String : Any]]
                    print(self.users)
                    
                    self.loading.stopAnimating()
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
    
    func setupStudentsSearchByDoctorAPI(searchWord: String) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["searchKey" : searchWord, "userId" : userId]
        
        Alamofire.request(APIs.studentsSearchByDoctor(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.users = responseValue["students"] as! [[String : Any]]
                    print(self.users)
                    
                    self.loading.stopAnimating()
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
}

extension searchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loading.startAnimating()
        if searchText != "" {
            searchBar.setShowsCancelButton(true, animated: true)
            
            if optionSegmentedControl.selectedSegmentIndex == 0 {
                if UserDefaults.standard.string(forKey: "userType")! == "Student" {
                    setupStudentsSearchByStudentAPI(searchWord: searchText)
                }else{
                    setupStudentsSearchByDoctorAPI(searchWord: searchText)
                }
            }else{
                setupDoctorsSearchAPI(searchWord: searchText)
            }
            
        }else {
            searchBar.setShowsCancelButton(false, animated: true)
            
            if optionSegmentedControl.selectedSegmentIndex == 0 {
                if UserDefaults.standard.string(forKey: "userType")! == "Student" {
                    setupStudentsByStudentAPI()
                }else{
                    setupStudentsByDoctorAPI()
                }
            }else{
                setupDoctorsAPI()
            }
        }
            
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        
        searchBar.setShowsCancelButton(false, animated: true)
        
        if optionSegmentedControl.selectedSegmentIndex == 0 {
            if UserDefaults.standard.string(forKey: "userType")! == "Student" {
                setupStudentsByStudentAPI()
            }else{
                setupStudentsByDoctorAPI()
            }
        }else{
            setupDoctorsAPI()
        }
        
    }
}

extension searchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        
        let singleUser = users[indexPath.row]
        
        let profilePicture = user.viewWithTag(1) as! UIImageView
        if singleUser["ProfileImagePath"] != nil {
            profilePicture.sd_setImage(with: URL(string: singleUser["ProfileImagePath"] as! String), completed: nil)
        }else {
            profilePicture.image = UIImage(named: "login user")
        }
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.label.cgColor
        
        let userNameLbl = user.viewWithTag(2) as! UILabel
        userNameLbl.text! = singleUser["Name"] as! String
        
        let userEmailLbl = user.viewWithTag(3) as! UILabel
        userEmailLbl.text! = singleUser["Email"] as! String
        
        return user
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let singleUser = users[indexPath.row]
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        profileViewController.modalPresentationStyle = .fullScreen
        if singleUser["_id"] as! String == userId {
            profileViewController.mineFlag = true
        }else{
            profileViewController.mineFlag = false
        }
        profileViewController.userId = singleUser["_id"] as! String
        present(profileViewController, animated: true, completion: nil)
        
    }
}

extension searchViewController {
    @objc func refreshAction(_ sender: AnyObject){
        loading.startAnimating()
        if optionSegmentedControl.selectedSegmentIndex == 0 {
            if UserDefaults.standard.string(forKey: "userType")! == "Student" {
                setupStudentsByStudentAPI()
            }else{
                setupStudentsByDoctorAPI()
            }
        }else{
            setupDoctorsAPI()
        }
    }
}
