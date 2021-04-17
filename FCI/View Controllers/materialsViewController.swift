//
//  materialsViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/6/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class materialsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addMaterialBtn: UIButton!

    var refreshControl = UIRefreshControl()
    var materials = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            addMaterialBtn.isHidden = true
            setupMaterialsByLevelAPI()
        }else {
            setupMaterialsByDoctorAPI()
        }
        
        
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMaterialAction(_ sender: Any) {
        let addMaterialViewController = self.storyboard?.instantiateViewController(withIdentifier: "addMaterialViewController") as! addMaterialViewController
        addMaterialViewController.modalPresentationStyle = .fullScreen
        present(addMaterialViewController, animated: true, completion: nil)
    }
}

extension materialsViewController {
    func setupMaterialsByLevelAPI() {
        let level = UserDefaults.standard.string(forKey: "level")!
        
        Alamofire.request(APIs.getMaterialsByLevel(level: level), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.materials = responseValue["material"] as! [[String : Any]]
                    print(self.materials)
                    
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
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
    
    func setupMaterialsByDoctorAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        Alamofire.request(APIs.getMaterialsByDoctor(userId: userId), method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.value != nil {
                let responseValue = response.value as! [String : Any]
                
                if responseValue["success"] as! Bool {
                    self.materials = responseValue["material"] as! [[String : Any]]
                    print(self.materials)
                    
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
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

extension materialsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.25, height: 235)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return materials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.label.cgColor
        cell.layer.cornerRadius = cell.frame.height/25
        
        let singleMaterial = materials[indexPath.row]
        let materialUploader = singleMaterial["materialuploader"] as! [String : String]
        
        let image = cell.viewWithTag(1) as! UIImageView
        switch singleMaterial["materialType"] as! String {
        case "application/pdf":
            image.image = UIImage(named: "pdf")
        case "application/vnd.openxmlformats-officedocument.presentationml.presentation":
            image.image = UIImage(named: "power point")
        case "application/vnd.openxmlformats-officedocument.wordprocessingml.document":
            image.image = UIImage(named: "word")
        case "application/x-zip-compressed":
            image.image = UIImage(named: "compressed")
        case "text/plain":
            image.image = UIImage(named: "text")
        default:
            image.image = UIImage(systemName: "doc.fill")
        }
        
        let nameLbl = cell.viewWithTag(2) as! UILabel
        nameLbl.text! = singleMaterial["description"] as! String
        
        let levelLbl = cell.viewWithTag(3) as! UILabel
        switch singleMaterial["Level"] as! String{
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
        
        let uploaderLbl = cell.viewWithTag(4) as! UILabel
        uploaderLbl.text! = "\(materialUploader["title"]!) \(materialUploader["Name"]!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleMaterial = materials[indexPath.row]
        
        UIApplication.shared.open(URL(string: singleMaterial["FilePath"] as! String)!, options: [:], completionHandler: nil)
    }
}

extension materialsViewController {
    @objc func refreshAction(_ sender: AnyObject){
        if UserDefaults.standard.string(forKey: "userType")! == "Student" {
            setupMaterialsByLevelAPI()
        }else {
            setupMaterialsByDoctorAPI()
        }
    }
}

