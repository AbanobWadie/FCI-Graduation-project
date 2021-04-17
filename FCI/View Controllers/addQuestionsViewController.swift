//
//  addQuestionsViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/7/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire

class addQuestionsViewController: UIViewController {

    @IBOutlet weak var questionNumLbl: UILabel!
    @IBOutlet weak var questionTxt: UITextField!
    @IBOutlet weak var optionATxt: UITextField!
    @IBOutlet weak var optionBTxt: UITextField!
    @IBOutlet weak var optionCTxt: UITextField!
    @IBOutlet weak var optionDTxt: UITextField!
    @IBOutlet weak var rightAnswerTxt: UITextField!
    @IBOutlet weak var addQuestionBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var quizId = String()
    var pickerView = UIPickerView()
    var answers = ["Option A", "Option B", "Option C", "Option D"]
    var answerSymbol = ["1", "2", "3", "4"]
    var row = 0
    var counter = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
        questionNumLbl.text! = "Question #\(counter) :"
        
        rightAnswerTxt.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addQuestionAction(_ sender: Any) {
        if questionTxt.text! != "" {
            if optionATxt.text! != "" && optionBTxt.text! != "" && optionCTxt.text! != "" && optionDTxt.text! != "" {
                if rightAnswerTxt.text! != "" {
                    setupAddQuestionToQuizAPI()
                }else{
                    let alert = UIAlertController(title: "sorry", message: "You must select right answer first", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: "You must write all option", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "sorry", message: "You must write the question", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    @IBAction func finishAction(_ sender: Any) {
        let alert = UIAlertController(title: "Done", message: "Quiz added succesfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            let quizViewController = self.storyboard?.instantiateViewController(withIdentifier: "quizViewController") as! quizViewController
            quizViewController.modalPresentationStyle = .fullScreen
            quizViewController.DismissFlag = true
            self.present(quizViewController, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension addQuestionsViewController {
    func layouts() {
        if #available(iOS 13.0, *) {
            questionTxt.layer.borderColor = UIColor.label.cgColor
        }
        questionTxt.layer.borderWidth = 2
        questionTxt.layer.masksToBounds = true
        questionTxt.layer.cornerRadius = questionTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            optionATxt.layer.borderColor = UIColor.label.cgColor
        }
        optionATxt.layer.borderWidth = 2
        optionATxt.layer.masksToBounds = true
        optionATxt.layer.cornerRadius = optionATxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            optionBTxt.layer.borderColor = UIColor.label.cgColor
        }
        optionBTxt.layer.borderWidth = 2
        optionBTxt.layer.masksToBounds = true
        optionBTxt.layer.cornerRadius = optionBTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            optionCTxt.layer.borderColor = UIColor.label.cgColor
        }
        optionCTxt.layer.borderWidth = 2
        optionCTxt.layer.masksToBounds = true
        optionCTxt.layer.cornerRadius = optionCTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            optionATxt.layer.borderColor = UIColor.label.cgColor
        }
        optionDTxt.layer.borderWidth = 2
        optionDTxt.layer.masksToBounds = true
        optionDTxt.layer.cornerRadius = optionDTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            optionDTxt.layer.borderColor = UIColor.label.cgColor
        }
        rightAnswerTxt.layer.borderWidth = 2
        rightAnswerTxt.layer.masksToBounds = true
        rightAnswerTxt.layer.borderColor = UIColor.label.cgColor
        rightAnswerTxt.layer.cornerRadius = rightAnswerTxt.frame.height/2
        
        addQuestionBtn.layer.masksToBounds = true
        addQuestionBtn.layer.cornerRadius = addQuestionBtn.frame.height/2
        
        finishBtn.layer.masksToBounds = true
        finishBtn.layer.cornerRadius = finishBtn.frame.height/2
    }
    
    func setupAddQuestionToQuizAPI() {
        loading.startAnimating()
        
        let parameter = ["question" : questionTxt.text!, "quizId" : quizId, "answer" : answerSymbol[row], "option1" : optionATxt.text!, "option2" : optionBTxt.text!, "option3" : optionCTxt.text!, "option4" : optionDTxt.text!]
        
        Alamofire.request(APIs.addQuestionToQuiz(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.loading.stopAnimating()
                    
                    let alert = UIAlertController(title: "Done", message: (responseValue["messages"] as! String), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                        self.counter += 1
                        self.questionNumLbl.text! = "Question #\(self.counter) :"
                        
                        self.questionTxt.text! = ""
                        self.optionATxt.text! = ""
                        self.optionBTxt.text! = ""
                        self.optionCTxt.text! = ""
                        self.optionDTxt.text! = ""
                        self.rightAnswerTxt.text! = ""
                        self.finishBtn.isHidden = false
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
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

extension addQuestionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return answers.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel? = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.font = UIFont(name: "kefa", size: 20)
            label?.textAlignment = .center
        }
        
        rightAnswerTxt.text! = answers[self.row]
        label?.text = answers[row]
        
        return label!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        rightAnswerTxt.text! = answers[row]
        self.row = row
    }
}

