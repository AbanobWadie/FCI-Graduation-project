//
//  quizViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/6/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class quizViewController: UIViewController {

    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var addQuizBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optionsegmentedControl: UISegmentedControl!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var quizes = [[String : Any]]()
    var DismissFlag = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        loading.startAnimating()
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            addQuizBtn.isHidden = true
            optionView.isHidden = false
            setupQuizByLevelAPI()
        }else{
            addQuizBtn.isHidden = false
            optionView.isHidden = true
            setupQuizByDocOrDoneAPI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func optionSelector(_ sender: Any) {
        loading.startAnimating()
        if optionsegmentedControl.selectedSegmentIndex == 0 {
            setupQuizByLevelAPI()
        }else{
            setupQuizByDocOrDoneAPI()
        }
    }
    
    @IBAction func addQuizAction(_ sender: Any) {
        let addQuizViewController = storyboard?.instantiateViewController(withIdentifier: "addQuizViewController") as! addQuizViewController
        addQuizViewController.modalPresentationStyle = .fullScreen
        present(addQuizViewController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if DismissFlag {
            let level = UserDefaults.standard.string(forKey: "level")!
            
            let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
            homeViewController.modalPresentationStyle = .fullScreen
            homeViewController.level = level
            present(homeViewController, animated: true, completion: nil)
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension quizViewController {
    func setupQuizByLevelAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getQuizByLevel(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.quizes = responseValue["quizes"] as! [[String : Any]]
                    print(self.quizes)
                    
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
    
    func setupQuizByDocOrDoneAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getQuizByDocOrDone(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.quizes = responseValue["quizes"] as! [[String : Any]]
                    print(self.quizes)
                    
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

extension quizViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quiz = tableView.dequeueReusableCell(withIdentifier: "quiz", for: indexPath) as! quizTableViewCell
        
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let singleQuiz = quizes[indexPath.section]
        let quizUploader = singleQuiz["quizUploader"] as! [String : String]
        
        
        let nameLbl = quiz.nameLbl!
        nameLbl.text! = singleQuiz["Title"] as! String
        
        let levelLbl = quiz.levelLbl!
        switch singleQuiz["Level"] as! String{
        case "1":
            levelLbl.text! = "First Grade"
        case "2":
            levelLbl.text! = "Second Grade"
        case "3cs":
            levelLbl.text! = "Third Grade (CS)"
        case "3is":
            levelLbl.text! = "Third Grade (IS)"
        case "4cs":
            levelLbl.text! = "Fourth Grade (CS)"
        case "4is":
            levelLbl.text! = "Fourth Grade (IS)"
        default:
            levelLbl.text! = "General"
        }
        
        let questionNumLbl = quiz.questionNumLbl!
        questionNumLbl.text! = "\(singleQuiz["QuestionNum"]!) Questions"
        
        let optionBtn = quiz.optionBtn!
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            if optionsegmentedControl.selectedSegmentIndex == 0 {
                let StudentDone = singleQuiz["StudentDone"] as! [String]
                var flag = true
                for item in StudentDone {
                    if item == userId {
                        flag = false
                        break
                    }
                }
                if flag {
                    optionBtn.isEnabled = true
                    optionBtn.alpha = 1
                    optionBtn.setTitle("Start", for: .normal)
                }else {
                    optionBtn.isEnabled = false
                    optionBtn.alpha = 0.5
                    optionBtn.setTitle("Done", for: .normal)
                }
            }else{
                optionBtn.setTitle("Result", for: .normal)
            }
        }else{
            optionBtn.setTitle("Result", for: .normal)
        }
        
        optionBtn.layer.masksToBounds = true
        optionBtn.layer.cornerRadius = optionBtn.frame.height/2
        optionBtn.tag = indexPath.section
        optionBtn.addTarget(self, action: #selector(optionAction), for: .touchUpInside)
        
        let userImageBtn = quiz.userImageBtn!
        userImageBtn.sd_setBackgroundImage(with: URL(string: quizUploader["ProfileImagePath"]!), for: .normal, completed: nil)
        userImageBtn.layer.masksToBounds = true
        userImageBtn.layer.cornerRadius = userImageBtn.frame.height/2
        userImageBtn.layer.borderWidth = 2
        userImageBtn.tag = indexPath.section
        userImageBtn.addTarget(self, action: #selector(userNameImageAction), for: .touchUpInside)
        
        let userNameBtn = quiz.userNameBtn!
        userNameBtn.setTitle("\(quizUploader["title"]!) \(quizUploader["Name"]!)", for: .normal)
        userNameBtn.tag = indexPath.section
        userNameBtn.addTarget(self, action: #selector(userNameImageAction), for: .touchUpInside)
        
        let userEmaillbl = quiz.emailLbl!
        userEmaillbl.text! = quizUploader["Email"]!
        
        let dateTimelbl = quiz.dateTimeLbl!
        dateTimelbl.text! = singleQuiz["uploadDate"] as! String
        
        return quiz
    }
    
    
}

extension quizViewController {
    @objc func refreshAction(_ sender: AnyObject){
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            setupQuizByLevelAPI()
        }else{
            setupQuizByDocOrDoneAPI()
        }
        
    }
    
    @objc func optionAction(button: UIButton) {
        let singleQuiz = quizes[button.tag]
        
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            if optionsegmentedControl.selectedSegmentIndex == 0 {
                let questions = singleQuiz["questions"] as! [[String : Any]]
                
                let answerQuizViewController = storyboard?.instantiateViewController(withIdentifier: "answerQuizViewController") as! answerQuizViewController
                answerQuizViewController.modalPresentationStyle = .fullScreen
                answerQuizViewController.questions = questions
                answerQuizViewController.quizId = singleQuiz["_id"] as! String
                present(answerQuizViewController, animated: true, completion: nil)
                
            }else{
                let allResultsViewController = storyboard?.instantiateViewController(withIdentifier: "allResultsViewController") as! allResultsViewController
                allResultsViewController.modalPresentationStyle = .fullScreen
                allResultsViewController.quizId = singleQuiz["_id"] as! String
                present(allResultsViewController, animated: true, completion: nil)
            }
        }else{
            let allResultsViewController = storyboard?.instantiateViewController(withIdentifier: "allResultsViewController") as! allResultsViewController
            allResultsViewController.modalPresentationStyle = .fullScreen
            allResultsViewController.quizId = singleQuiz["_id"] as! String
            present(allResultsViewController, animated: true, completion: nil)
        }
    }
    
    @objc func userNameImageAction(button: UIButton) {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        let singleQuiz = quizes[button.tag]
        let quizUploader = singleQuiz["quizUploader"] as! [String : String]
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        profileViewController.modalPresentationStyle = .fullScreen
        profileViewController.userId = quizUploader["_id"]!
        if quizUploader["_id"]! == userId {
            profileViewController.mineFlag = true
        }else{
            profileViewController.mineFlag = false
        }
        present(profileViewController, animated: true, completion: nil)
    }

}
