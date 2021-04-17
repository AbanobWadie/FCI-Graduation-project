//
//  eventsViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/6/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class eventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openedImageView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewHeaderView: UIView!
    
    var refreshControl = UIRefreshControl()
    var events = [[String : String]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        setupEventsAPI()
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let tapGestur = UITapGestureRecognizer(target: self, action: #selector(showHeader))
        openedImageView.addGestureRecognizer(tapGestur)
        openedImageView.addGestureRecognizer(tapGestur)
    }
    
    @IBAction func closePreviewAction(_ sender: Any) {
        previewView.isHidden = true
        previewHeaderView.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension eventsViewController {
    func setupEventsAPI() {
        
        Alamofire.request(APIs.getEvents(), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.events = responseValue["events"] as! [[String : String]]
                    print(self.events)
                    
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

extension eventsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let singleEvent = events[section]
        
        if singleEvent["image"]! != "" {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let singleEvent = events[indexPath.section]
        
        if indexPath.row == 0 && singleEvent["image"]! != ""  {
            let eventPic = tableView.dequeueReusableCell(withIdentifier: "eventPic", for: indexPath)
            
            let imageView = eventPic.viewWithTag(1) as! UIImageView
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = imageView.frame.height/25
            if singleEvent["image"]! != "" {
                imageView.isHidden = false
                imageView.sd_setImage(with: URL(string: singleEvent["image"]!), completed: nil)
            }else{
                imageView.isHidden = true
            }
            return eventPic
        }else {
            let eventDetails = tableView.dequeueReusableCell(withIdentifier: "eventDetails", for: indexPath) as! eventDetailsTableViewCell
            
            let titleLbl = eventDetails.titleLbl!
            titleLbl.text! = singleEvent["title"]!
            
            let dateTimeLbl = eventDetails.dateTimeLbl!
            dateTimeLbl.text! = singleEvent["uploadDate"]!
            
            let detailsTxt = eventDetails.detailsTxt!
            detailsTxt.text! = singleEvent["Description"]!
            
            let detailsTxtHieght = eventDetails.detailsTxtHieght!
            let linesCount: Int = (detailsTxt.text!.count / 50) + 1
            detailsTxtHieght.constant = CGFloat(linesCount * 40)
            
            return eventDetails
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            previewView.isHidden = false
            let singleEvent = events[indexPath.section]
            openedImageView.sd_setImage(with: URL(string: singleEvent["image"]!), completed: nil)
        }
    }
}

extension eventsViewController {
    @objc func refreshAction(_ sender: AnyObject){
        setupEventsAPI()
    }
    
    @objc func showHeader() {
        previewHeaderView.isHidden = !previewHeaderView.isHidden
    }
}
