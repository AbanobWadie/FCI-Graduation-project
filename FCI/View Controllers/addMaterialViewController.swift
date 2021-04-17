//
//  addMaterialViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/6/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class addMaterialViewController: UIViewController {

    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var gradeSelectionTxt: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var fileLbl: UILabel!
    
    var fileUrl: URL!
    var fileExtension = String()
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
    
    @IBAction func pickDocumentAction(_ sender: Any) {
        if fileUrl != nil {
            let options = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
            options.addAction(UIAlertAction(title: "Change Document", style: .default, handler: { (action) in
                self.pickDocument()
            }))
            options.addAction(UIAlertAction(title: "Remove Document", style: .destructive, handler: { (action) in
                self.fileUrl = nil
                self.fileLbl.text! = ""
                self.fileExtension = ""
                self.fileLbl.isHidden = true
            }))
            options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(options, animated: true, completion: nil)
        }else{
            pickDocument()
        }
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        if fileUrl != nil {
            if descriptionTxt.text! != "" {
                if gradeSelectionTxt.text! != "" {
                    setupAddMaterialAPI()
                }else{
                    let alert = UIAlertController(title: "sorry", message: "You must select grade first", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "sorry", message: "You must write description", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "sorry", message: "You must pick document first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension addMaterialViewController {
    func layouts() {
        if #available(iOS 13.0, *) {
            descriptionTxt.layer.borderColor = UIColor.label.cgColor
        }
        descriptionTxt.layer.borderWidth = 2
        descriptionTxt.layer.masksToBounds = true
        descriptionTxt.layer.cornerRadius = descriptionTxt.frame.height/2
        
        if #available(iOS 13.0, *) {
            gradeSelectionTxt.layer.borderColor = UIColor.label.cgColor
        }
        gradeSelectionTxt.layer.borderWidth = 2
        gradeSelectionTxt.layer.masksToBounds = true
        gradeSelectionTxt.layer.cornerRadius = gradeSelectionTxt.frame.height/2
        
        uploadBtn.layer.masksToBounds = true
        uploadBtn.layer.cornerRadius = uploadBtn.frame.height/2
    }
    
    func setupAddMaterialAPI() {
        let userId = UserDefaults.standard.string(forKey: "userId")!
        
        let parameter = ["description" : descriptionTxt.text!, "userId" : userId, "level" : gradeSymbol[row]]
            
        var mediaData = Data()
        do {
            mediaData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
        }catch {}
               
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
                   
            MultipartFormData.append(mediaData, withName: "file", fileName: "material.\(self.fileExtension)", mimeType: "file/\(self.fileExtension)")
                   
            for (key, value) in parameter {
                       
                MultipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                       
            }
                   
        }, usingThreshold: UInt64.init() , to: APIs.createPostByLevel() , method: .post) { (result) in
                   
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { (progress) in
                    print(progress.fractionCompleted)
                           
                    self.progressView.isHidden = false
                    self.progressView.progress = Float(progress.fractionCompleted)
                }
                       
                upload.responseJSON { (response) in
                    if response.response?.statusCode == 200 {
                        let responseValue = response.result.value as! [String : Any]
                        if responseValue["success"] as! Bool {
                            self.progressView.isHidden = true
                            self.fileUrl = nil
                            self.fileLbl.text! = ""
                            self.fileExtension = ""
                            self.fileLbl.isHidden = true
                            
                            let alert = UIAlertController(title: "Done", message: (responseValue["message"] as! String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }else {
                            let alert = UIAlertController(title: "sorry", message: (responseValue["message"] as! String), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                       
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension addMaterialViewController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    func pickDocument() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeText), String(kUTTypeItem)], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .fullScreen
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentUrl = urls.first else {
            return
        }
        print("file url : \(documentUrl)")
        fileLbl.isHidden = false
        fileLbl.text! = "Document.\(documentUrl.pathExtension)"
        fileUrl = documentUrl
        fileExtension = documentUrl.pathExtension
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension addMaterialViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

