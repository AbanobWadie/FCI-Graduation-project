//
//  quizResultViewController.swift
//  FCI
//
//  Created by Abanob Wadie on 8/7/20.
//  Copyright © 2020 Abanob Wadie. All rights reserved.
//

import UIKit

class quizResultViewController: UIViewController {

    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var result = String()
    var total = String()
    var delay: Timer!
    let shapelayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        layouts()
        
        resultLbl.text! = result
        resultProgress(x: 205, y: 220)
    }
    
    @IBAction func backAction(_ sender: Any) {
        let quizViewController = storyboard?.instantiateViewController(withIdentifier: "quizViewController") as! quizViewController
        quizViewController.modalPresentationStyle = .fullScreen
        quizViewController.DismissFlag = true
        present(quizViewController, animated: true, completion: nil)
    }
}

extension quizResultViewController {
    func layouts() {
        backBtn.layer.masksToBounds = true
        backBtn.layer.cornerRadius = backBtn.frame.height/2
    }
    
    func resultProgress (x: Int, y: Int) {
        let point = CGPoint(x: x, y: y)
        let circularPath = UIBezierPath(arcCenter: point, radius: 75, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        tracklayer.path = circularPath.cgPath
        tracklayer.strokeColor = UIColor(red: 3/255, green: 65/255, blue: 124/255, alpha: 1).cgColor
        tracklayer.lineWidth = 3
        tracklayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(tracklayer)
        
        
        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = UIColor.label.cgColor
        shapelayer.lineWidth = 10
        shapelayer.fillColor = UIColor.clear.cgColor
        shapelayer.lineCap = .butt
        shapelayer.strokeEnd = 0
        shapelayer.shadowOpacity = 0.4
        view.layer.addSublayer(shapelayer)
        
        
        delay = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.delayFunc), userInfo: nil, repeats: false)
    }
    
    @objc func delayFunc() {
        let res: Float = Float(result)!/Float(total)!
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = res
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapelayer.add(basicAnimation, forKey: "urSoBasic")
        delay.invalidate()
    }
}
