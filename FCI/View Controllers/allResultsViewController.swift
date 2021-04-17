//
//  allResultsViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/8/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire

class allResultsViewController: UIViewController {

    @IBOutlet weak var quizNameLbl: UILabel!
    @IBOutlet weak var quizUploaderTpotalLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var quizId = String()
    var results = [[String : Any]]()
    var quiz = [String : Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupquizResultsAPI()
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension allResultsViewController {
    func setData() {
        let quizUploader = quiz["quizUploader"] as! [String : String]
        
        quizNameLbl.text! = quiz["Title"] as! String
        quizUploaderTpotalLbl.text! = "Dr: \(quizUploader["Name"]!)     Total: \(quiz["QuestionNum"] as! String)"
        
    }
    
    func setupquizResultsAPI() {
        loading.startAnimating()
                
        Alamofire.request(APIs.getAllResults(quizId: quizId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.loading.stopAnimating()
                    self.results = responseValue["results"] as! [[String : Any]]
                    self.quiz = responseValue["quiz"] as! [String : Any]
                    
                    self.setData()
                    
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
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

extension allResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = tableView.dequeueReusableCell(withIdentifier: "studentMark", for: indexPath)
        
        let singleResult = results[indexPath.section]
        let studentInfo = singleResult["student"] as! [String : Any]
        
        let studentNum = student.viewWithTag(1) as! UILabel
        studentNum.text! = "\(indexPath.section + 1)."
        
        let studentName = student.viewWithTag(2) as! UILabel
        studentName.text! = studentInfo["Name"] as! String
        
        let studentMark = student.viewWithTag(3) as! UILabel
        studentMark.text! = singleResult["Result"] as! String
           
        return student
    }
}

extension allResultsViewController {
    @objc func refreshAction(_ sender: AnyObject){
        setupquizResultsAPI()
    }
}
