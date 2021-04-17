//
//  answerQuizViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/7/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire

class answerQuizViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var questions = [[String : Any]]()
    var quizId = String()
    var result = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        result = [Bool](repeating: false, count: questions.count)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension answerQuizViewController {
    func setupCorrectQuizAPI(result: String) {
        loading.startAnimating()
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["studentId" : userId, "quizId" : quizId, "result" : result]
        
        Alamofire.request(APIs.correctQuiz(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.loading.stopAnimating()
                    
                    let quizResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "quizResultViewController") as! quizResultViewController
                    quizResultViewController.modalPresentationStyle = .fullScreen
                    quizResultViewController.result = result
                    quizResultViewController.total = "\(self.questions.count)"
                    self.present(quizResultViewController, animated: true, completion: nil)
                    
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

extension answerQuizViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section != questions.count {
            let quizSheet = tableView.dequeueReusableCell(withIdentifier: "quizSheet", for: indexPath) as! quizSheetTableViewCell
            
            let singleQuestion = questions[indexPath.section]
            
            let questionNumLbl = quizSheet.questionNumLbl!
            questionNumLbl.text! = "Question #\(indexPath.section + 1) :"
            
            let questionLbl = quizSheet.questionLbl!
            questionLbl.text! = singleQuestion["question"] as! String
            
            let optionABtn = quizSheet.optionABtn!
            optionABtn.layer.masksToBounds = true
            optionABtn.layer.cornerRadius = optionABtn.frame.height/2
            optionABtn.layer.borderWidth = 2
            optionABtn.layer.borderColor = UIColor.label.cgColor
            optionABtn.tag = indexPath.section
            optionABtn.setTitle("  🅰 \(singleQuestion["option1"] as! String)", for: .normal)
            optionABtn.addTarget(self, action: #selector(optionAAction), for: .touchUpInside)
            
            let optionBBtn = quizSheet.optionBBtn!
            optionBBtn.layer.masksToBounds = true
            optionBBtn.layer.cornerRadius = optionBBtn.frame.height/2
            optionBBtn.layer.borderWidth = 2
            optionBBtn.layer.borderColor = UIColor.label.cgColor
            optionBBtn.tag = indexPath.section
            optionBBtn.setTitle("  🅱 \(singleQuestion["option2"] as! String)", for: .normal)
            optionBBtn.addTarget(self, action: #selector(optionBAction), for: .touchUpInside)
            
            let optionCBtn = quizSheet.optionCBtn!
            optionCBtn.layer.masksToBounds = true
            optionCBtn.layer.cornerRadius = optionCBtn.frame.height/2
            optionCBtn.layer.borderWidth = 2
            optionCBtn.layer.borderColor = UIColor.label.cgColor
            optionCBtn.tag = indexPath.section
            optionCBtn.setTitle("  🅲 \(singleQuestion["option3"] as! String)", for: .normal)
            optionCBtn.addTarget(self, action: #selector(optionCAction), for: .touchUpInside)
            
            let optionDBtn = quizSheet.optionDBtn!
            optionDBtn.layer.masksToBounds = true
            optionDBtn.layer.cornerRadius = optionDBtn.frame.height/2
            optionDBtn.layer.borderWidth = 2
            optionDBtn.layer.borderColor = UIColor.label.cgColor
            optionDBtn.tag = indexPath.section
            optionDBtn.setTitle("  🅳 \(singleQuestion["option4"] as! String)", for: .normal)
            optionDBtn.addTarget(self, action: #selector(optionDAction), for: .touchUpInside)
            
            
            if singleQuestion["__v"] as! Int == 1 {
                optionABtn.backgroundColor = .blue
                optionBBtn.backgroundColor = .clear
                optionCBtn.backgroundColor = .clear
                optionDBtn.backgroundColor = .clear
            }else if singleQuestion["__v"] as! Int == 2 {
                optionABtn.backgroundColor = .clear
                optionBBtn.backgroundColor = .blue
                optionCBtn.backgroundColor = .clear
                optionDBtn.backgroundColor = .clear
            }else if singleQuestion["__v"] as! Int == 3 {
                optionABtn.backgroundColor = .clear
                optionBBtn.backgroundColor = .clear
                optionCBtn.backgroundColor = .blue
                optionDBtn.backgroundColor = .clear
            }else if singleQuestion["__v"] as! Int == 4 {
                optionABtn.backgroundColor = .clear
                optionBBtn.backgroundColor = .clear
                optionCBtn.backgroundColor = .clear
                optionDBtn.backgroundColor = .blue
            }
            
            return quizSheet
        }else{
            let submit = tableView.dequeueReusableCell(withIdentifier: "submit", for: indexPath) as! submitTableViewCell
            
            let submitBtn = submit.submitBtn!
            submitBtn.layer.masksToBounds = true
            submitBtn.layer.cornerRadius = submitBtn.frame.height/2
            submitBtn.tag = indexPath.section
            submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
            
            return submit
        }
    }
}

extension answerQuizViewController {
    @objc func optionAAction(button: UIButton) {
        var singleQuestion = questions[button.tag]
        let answer = singleQuestion["answer"] as! String
        
        if answer == "1" {
            result[button.tag] = true
        }else{
            result[button.tag] = false
        }
        
        singleQuestion.updateValue(1, forKey: "__v")
        
        questions.remove(at: button.tag)
        questions.insert(singleQuestion, at: button.tag)
        
        let section = IndexSet.init(integer: button.tag)
        tableView.reloadSections(section, with: .fade)
    }
    
    @objc func optionBAction(button: UIButton) {
        var singleQuestion = questions[button.tag]
        let answer = singleQuestion["answer"] as! String
        
        print(singleQuestion["__v"]!)
        if answer == "2" {
            result[button.tag] = true
        }else{
            result[button.tag] = false
        }
        
        singleQuestion.updateValue(2, forKey: "__v")
        
        questions.remove(at: button.tag)
        questions.insert(singleQuestion, at: button.tag)
        
        let section = IndexSet.init(integer: button.tag)
        tableView.reloadSections(section, with: .fade)
    }
    
    @objc func optionCAction(button: UIButton) {
        var singleQuestion = questions[button.tag]
        let answer = singleQuestion["answer"] as! String
        
        if answer == "3" {
            result[button.tag] = true
        }else{
            result[button.tag] = false
        }
        
        singleQuestion.updateValue(3, forKey: "__v")
        
        questions.remove(at: button.tag)
        questions.insert(singleQuestion, at: button.tag)
        
        let section = IndexSet.init(integer: button.tag)
        tableView.reloadSections(section, with: .fade)
    }
    
    @objc func optionDAction(button: UIButton) {
        var singleQuestion = questions[button.tag]
        let answer = singleQuestion["answer"] as! String
        
        if answer == "4" {
            result[button.tag] = true
        }else{
            result[button.tag] = false
        }
        
        singleQuestion.updateValue(4, forKey: "__v")
        
        questions.remove(at: button.tag)
        questions.insert(singleQuestion, at: button.tag)
        
        let section = IndexSet.init(integer: button.tag)
        tableView.reloadSections(section, with: .fade)
    }
    
    @objc func submitAction(button: UIButton) {
        var resCount = 0
        
        for res in result {
            if res {
                resCount += 1
            }
        }
        setupCorrectQuizAPI(result: "\(resCount)")
    }
}
