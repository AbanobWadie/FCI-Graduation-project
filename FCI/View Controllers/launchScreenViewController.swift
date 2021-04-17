//
//  launchScreenViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/5/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class launchScreenViewController: UIViewController {

    var timer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.progress), userInfo: nil, repeats: true)
    }
    
    @objc func progress() {
            
        timer.invalidate()
            
        if UserDefaults.standard.object(forKey: "userId") != nil {
            let level = UserDefaults.standard.string(forKey: "level")!
            
            let homeViewController = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
            homeViewController.modalPresentationStyle = .fullScreen
            homeViewController.level = level
            present(homeViewController, animated: true, completion: nil)
            
        }
        
        else {
            
            let loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
            
        }
    }
}
