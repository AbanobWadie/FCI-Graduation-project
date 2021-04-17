//
//  loginViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 7/28/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire

class loginViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var typeSelection: UISegmentedControl!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if emailTxt.text! != "" {
            if passwordTxt.text! != "" {
                
                setupLoginAPI()
                
            }else{
                let alert = UIAlertController(title: "sorry", message: "Password is required", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "sorry", message: "Email is required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func forgetPasswordAction(_ sender: Any) {
    }
}

extension loginViewController {
    func layouts() {
        emailTxt.layer.masksToBounds = true
        emailTxt.layer.cornerRadius = emailTxt.frame.height/2
        emailTxt.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            emailTxt.layer.borderColor = UIColor.label.cgColor
        }
        
        passwordTxt.layer.masksToBounds = true
        passwordTxt.layer.cornerRadius = passwordTxt.frame.height/2
        passwordTxt.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            passwordTxt.layer.borderColor = UIColor.label.cgColor
        }
        
        typeSelection.layer.masksToBounds = true
        typeSelection.layer.cornerRadius = typeSelection.frame.height/2
        
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = loginBtn.frame.height/2
    }
    
    
    func setupLoginAPI() {
        loading.startAnimating()
        let parameters = ["email" : emailTxt.text!, "password" : passwordTxt.text!, "title" : typeSelection.titleForSegment(at: typeSelection.selectedSegmentIndex)!]
        
        Alamofire.request(APIs.login(), method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.loading.stopAnimating()
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    print(responseValue)
                    UserDefaults.standard.set(responseValue["userId"] as! String, forKey: "userId")
                    UserDefaults.standard.set(self.typeSelection.titleForSegment(at: self.typeSelection.selectedSegmentIndex)!, forKey: "userType")
                    
                    
                    if self.typeSelection.selectedSegmentIndex == 0 {
                        UserDefaults.standard.set(responseValue["level"] as! String, forKey: "level")
                    }else{
                        UserDefaults.standard.set("1", forKey: "level")
                    }
                    
                    
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
                    homeViewController.modalPresentationStyle = .fullScreen
                    if self.typeSelection.selectedSegmentIndex == 0 {
                        homeViewController.level = responseValue["level"] as! String
                    }else{
                        homeViewController.level = "1"
                    }
                    self.present(homeViewController, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "sorry", message: (responseValue["message"] as! String), preferredStyle: .alert)
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
