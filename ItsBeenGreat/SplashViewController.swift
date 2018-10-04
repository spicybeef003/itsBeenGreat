//
//  SplashViewController.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/27/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var rightH: UIImageView!
    @IBOutlet weak var leftH: UIImageView!
    @IBOutlet weak var ruler: UIImageView!
    
    var text1Label: UILabel!
    var text2Label: UILabel!
    
    let splashFont = UIFont(name: "Precious", size: (Env.iPad ? 105 : 70))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        makeNavTransparent()
        view.backgroundColor = mistyrose
        
        loadText()
        
        leftH.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        rightH.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        ruler.center = CGPoint(x: view.frame.width/2, y: view.frame.height*1.5)
       
        text1Label.alpha = 0
        text2Label.alpha = 0
        
        UIView.animate(withDuration: 2.0, animations: {
           self.ruler.center = CGPoint(x: self.view.frame.width/2, y: -self.view.frame.height*0.5)
        }, completion: { _ in
            UIView.animate(withDuration: 1.5, animations: {
                self.leftH.frame.origin.x = self.leftH.frame.origin.x - 10
                self.rightH.frame.origin.x = self.rightH.frame.origin.x + self.rightH.frame.width/4
                self.rightH.frame.origin.y = self.rightH.frame.origin.y +  self.rightH.frame.height/6
                self.rightH.transform = CGAffineTransform(rotationAngle: (45 * CGFloat(Double.pi)) / 180.0)
            }, completion: { _ in
                UIView.animate(withDuration: 1.0, animations: {
                    self.text1Label.alpha = 1
                    //self.text2Label.alpha = 1
                }, completion: { _ in
                    UIView.animate(withDuration: 1.0, animations: {
                        //self.text1Label.alpha = 1
                        self.text2Label.alpha = 1
                    })
                })
            })
            
        })
        
        let when = DispatchTime.now() + 6.5 // change to # of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            let wd = self.view.window
            var vc = wd?.rootViewController!
            if vc is UINavigationController {
                vc = (vc as! UINavigationController).visibleViewController
            }
            if vc is SplashViewController {
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterInfoViewController") as! EnterInfoViewController
                self.navigationController?.pushViewController(myVC, animated: false)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadText() {
        let text1 = "It's Been"
        let text1Height = view.frame.height/4
        text1Label = UILabel(frame: CGRect(x: 0, y: rightH.frame.minY - text1Height - view.frame.height/20, width: view.frame.width, height: text1Height))
        text1Label.text = text1
        text1Label.textAlignment = .center
        text1Label.font = splashFont!
        text1Label.numberOfLines = 1
        text1Label.adjustsFontSizeToFitWidth = true
        text1Label.minimumScaleFactor = 0.5
        view.addSubview(text1Label)
        
        let text2 = "Great"
        let text2Height = view.frame.height/4
        text2Label = UILabel(frame: CGRect(x: 0, y: rightH.frame.maxY + view.frame.height/20, width: view.frame.width, height: text2Height))
        text2Label.text = text2
        text2Label.textAlignment = .center
        text2Label.font = splashFont!
        text2Label.numberOfLines = 1
        text2Label.adjustsFontSizeToFitWidth = true
        text2Label.minimumScaleFactor = 0.5
        view.addSubview(text2Label)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterInfoViewController") as! EnterInfoViewController
        self.navigationController?.pushViewController(myVC, animated: false)
    }

}

