//
//  addQuizViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/7/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire

class addQuizViewController: UIViewController {

    @IBOutlet weak var quizNameTxt: UITextField!
    @IBOutlet weak var gradeSelectionTxt: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var pickerView = UIPickerView()
    var grades = ["First Grade", "Second Grade", "Third Grade (CS)", "Third Grade (IS)", "Fourth Grade (CS)", "Fourth Grade (IS)"]
    var gradeSymbol = ["1", "2", "3cs", "3is", "4cs", "4is"]
    var row = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
        
        gradeSelectionTxt.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if quizNameTxt.text! != "" {
            if gradeSelectionTxt.text! != "" {
                setupAddQuizAPI()
            }else{
                let alert = UIAlertController(title: "sorry", message: "You must select grade first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "sorry", message: "You must write the name of quiz", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension addQuizViewController {
    func layouts() {
        if #available(iOS 13.0, *) {
            quizNameTxt.layer.borderColor = UIColor.label.cgColor
        }
        quizNameTxt.layer.borderWidth = 2
        quizNameTxt.layer.masksToBounds = true
        quizNameTxt.layer.cornerRadius = quizNameTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            gradeSelectionTxt.layer.borderColor = UIColor.label.cgColor
        }
        gradeSelectionTxt.layer.borderWidth = 2
        gradeSelectionTxt.layer.masksToBounds = true
        gradeSelectionTxt.layer.cornerRadius = gradeSelectionTxt.frame.height/2
        
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = nextBtn.frame.height/2
    }
    
    func setupAddQuizAPI() {
        loading.startAnimating()
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["title" : quizNameTxt.text!, "level" : gradeSymbol[row], "doctorId" : userId]
        
        Alamofire.request(APIs.addQuiz(), method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.loading.stopAnimating()
                    
                    let quiz = responseValue["newQuiz"] as! [String : String]
                    
                    let addQuestionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "addQuestionsViewController") as! addQuestionsViewController
                    addQuestionsViewController.modalPresentationStyle = .fullScreen
                    addQuestionsViewController.quizId = quiz["_id"]!
                    self.present(addQuestionsViewController, animated: true, completion: nil)
                    
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

extension addQuizViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return grades.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel? = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.font = UIFont(name: "kefa", size: 20)
            label?.textAlignment = .center
        }
        
        gradeSelectionTxt.text! = grades[self.row]
        label?.text = grades[row]
        
        return label!
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        gradeSelectionTxt.text! = grades[row]
        self.row = row
    }
}

