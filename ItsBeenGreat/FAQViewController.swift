//
//  FAQViewController.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/28/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    var FAQ: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let xint = view.frame.width/20
        let yint = view.frame.height/10
        let width = view.frame.width/10*9
        let height = view.frame.height/10*9
        
        FAQ = UITextView(frame: CGRect(x: xint, y: yint, width: width, height: height))
        FAQ.backgroundColor = UIColor.clear
        FAQ.isEditable = false
        FAQ.isScrollEnabled = true
        
        let formattedString = NSMutableAttributedString()
        let font:CGFloat = (Env.iPad ? 27 : 18)
        formattedString
            .bold("Frequently Asked Questions (FAQs)\n\n", font: 24)
            .bold("Q: ", font: font)
            .normal("What happens if he/she tries to contact me afterwards?\n\n", font: font)
            .bold("A: ", font: font)
            .normal("On the rare occasion this occurs, first, don’t panic! Second, be assured that the relationship is no longer your problem. You guys are officially done. Finished! Bonafide broken up! So let them contact you, because after all, at this point it just doesn’t matter.\n\n\n", font: font)
        
            .bold("Q: ", font: font)
            .normal("What information do I need to provide?\n\n", font: font)
            .bold("A: ", font: font)
            .normal("Your name (first, last or both), the name of the person getting dumped (first, last or both), the phone number of the person getting dumped, and reasons for breaking up (optional). There is also room for providing any other thoughts you would like to add.\n\n\n", font: font)
        
            .bold("Q: ", font: font)
            .normal("Whom do I contact if I have more questions?\n\n", font: font)
            .bold("A: ", font: font)
            .normal("Contact the Head Chief Promiscuous Liason Officer here: Bryan.Maliken@gmail.com", font: font)
        
        FAQ.attributedText = formattedString
        FAQ.dataDetectorTypes = .all
        view.addSubview(FAQ)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
