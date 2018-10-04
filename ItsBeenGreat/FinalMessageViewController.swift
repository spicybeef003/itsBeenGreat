//
//  FinalMessageViewController.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/12/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class FinalMessageViewController: UIViewController, AVSpeechSynthesizerDelegate, UITextViewDelegate, UITextFieldDelegate {
    let accountSID = "AC3e09621ec4bcae5fd2c5299d54fdd9fa"
    let authToken = "9553f1b0929f5496890ea00539f574bc"
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var endRelationshipButton: UIButton!
    @IBOutlet weak var purchaseMessagesButton: UIButton!
    @IBOutlet weak var progImage: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var receiveCopyLabel: UILabel!
    
    var mood: String!
    var userName: String!
    var name: String!
    var phone: String!
    var reason: Set<String>!
    var other: String!
    var more: String!
    
    var sendSMSButton: UIButton!
    
    var numMessages: Int!
    
    let synthesizer = AVSpeechSynthesizer()
    var flag: Int = 0
    var check:Int = 0
    
    var formattedText = NSMutableAttributedString()
    let fontSize:CGFloat = 20
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        formattedText = NSMutableAttributedString()
        setupText()
        
        numMessages = defaults.integer(forKey: "numMessages")
        self.navigationItem.rightBarButtonItem?.title = "Messages: \(defaults.integer(forKey: "numMessages"))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bkg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //self.navigationItem.title = "Confirm Message"
        
        synthesizer.delegate = self
        
        editButton(button: endRelationshipButton, text: "End your relationship now!", font: font!)
        endRelationshipButton.layer.cornerRadius = 0
        endRelationshipButton.backgroundColor = darkGreen
        
        editButton(button: purchaseMessagesButton, text: "Purchase Messages", font: font!)
        purchaseMessagesButton.layer.cornerRadius = 0
        
        var contentMessage: [String] = []
        for idx in reason.indices {
            contentMessage.append(reason[idx])
        }
        print(contentMessage)
        
        hideKeyboardWhenTappedAround()
        
        textView.returnKeyType = .done
        textView.flashScrollIndicators()
        textView.delegate = self
        
        phoneField.keyboardType = .decimalPad
        phoneField.delegate = self
        phoneField.isHidden = check == 0 ? true : false
        
        if check == 0 {
            checkboxButton.setImage(UIImage(named: "uncheckedbox"), for: .normal)
        }
        else {
            checkboxButton.setImage(UIImage(named: "checkedbox"), for: .normal)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        synthesizer.stopSpeaking(at: .immediate)
        flag = 0
    }
    
    func setupText() {
        mood = defaults.string(forKey: "mood") ?? "Professional"
        
        switch mood {
        case "Professional":
            formattedText
                .normal("Dear \(name!),\n\n", font: fontSize)
                .normal("This message is to inform you that \(userName!) is breaking up with you.\n\n", font: fontSize)
            if reason.contains("None") {
                formattedText.normal("\(userName!) has not listed any reasons for breaking up with you.\n\n", font: fontSize)
            }
            else if reason.contains("Decline") {
                formattedText.normal("\(userName!) has declined to list the reason for breaking up with you.\n\n", font: fontSize)
            }
            else {
                formattedText.normal("The primary reasons are listed:\n\n", font: fontSize)
                for idx in reason.indices {
                    switch reason[idx] {
                    case "Fallen out of love":
                        formattedText.normal("I \(Professional.fallen.rawValue).\n\n", font: fontSize)
                    case "He/she cheated on me":
                        formattedText.normal("\(Professional.cheated.rawValue) me.\n\n", font: fontSize)
                    case "He/she has changed":
                        formattedText.normal("I \(Professional.changed.rawValue).\n\n", font: fontSize)
                    case "Tired of him/her":
                        formattedText.normal("I \(Professional.tired.rawValue).\n\n", font: fontSize)
                    case "He/she is crazy":
                        formattedText.normal("I \(Professional.crazy.rawValue).\n\n", font: fontSize)
                    case "He/she drinks too much":
                        formattedText.normal("I \(Professional.drinker.rawValue).\n\n", font: fontSize)
                    case "He/she is smothering me":
                        formattedText.normal("\(Professional.smother.rawValue) me.\n\n", font: fontSize)
                    case "Found someone else":
                        formattedText.normal("I \(Professional.found.rawValue).\n\n", font: fontSize)
                    case "Not ready for a relationship":
                        formattedText.normal("I \(Professional.notReady.rawValue).\n\n", font: fontSize)
                    case "Need time for self-discovery":
                        formattedText.normal("I \(Professional.discover.rawValue).\n\n", font: fontSize)
                    default:
                        formattedText.normal("\(reason[idx]).\n\n", font: fontSize)
                    }
                }
            }
            
            if !more.isEmpty {
                formattedText.normal("\(userName!) also would like to add:\n\n'\(more!)'.\n\n", font: fontSize)
            }
        
        case "Sarcastic":
            formattedText
                .normal("\(name!),\n\n", font: fontSize)
                .normal("Let's be blunt. \(userName!) is breaking up with you\n\n", font: fontSize)
            if reason.contains("None") {
                formattedText.normal("\(userName!) has not listed any reasons for breaking up with you. Oh well.\n\n", font: fontSize)
            }
            else if reason.contains("Decline") {
                formattedText.normal("\(userName!) has declined to list the reason for breaking up with you. Oh well.\n\n", font: fontSize)
            }
            else {
                formattedText.normal("You're going to be single and here's why:\n\n", font: fontSize)
                for idx in reason.indices {
                    switch reason[idx] {
                    case "Fallen out of love":
                        formattedText.normal("I \(Sarcastic.fallen.rawValue).\n\n", font: fontSize)
                    case "He/she cheated on me":
                        formattedText.normal("\(Sarcastic.cheated.rawValue) me.\n\n", font: fontSize)
                    case "He/she has changed":
                        formattedText.normal("I \(Sarcastic.changed.rawValue)\n\n", font: fontSize)
                    case "Tired of him/her":
                        formattedText.normal("I \(Sarcastic.tired.rawValue).\n\n", font: fontSize)
                    case "He/she is crazy":
                        formattedText.normal("I \(Sarcastic.crazy.rawValue).\n\n", font: fontSize)
                    case "He/she drinks too much":
                        formattedText.normal("I \(Sarcastic.drinker.rawValue).\n\n", font: fontSize)
                    case "He/she is smothering me":
                        formattedText.normal("\(Sarcastic.smother.rawValue) me.\n\n", font: fontSize)
                    case "Found someone else":
                        formattedText.normal("I \(Sarcastic.found.rawValue).\n\n", font: fontSize)
                    case "Not ready for a relationship":
                        formattedText.normal("I \(Sarcastic.notReady.rawValue).\n\n", font: fontSize)
                    case "Need time for self-discovery":
                        formattedText.normal("I \(Sarcastic.discover.rawValue).\n\n", font: fontSize)
                    default:
                        formattedText.normal("\(reason[idx]).\n\n", font: fontSize)
                    }
                }
            }
            
            if !more.isEmpty {
                formattedText.normal("\(userName!) also would like to add:\n\n'\(more!)'.\n\n", font: fontSize)
            }
        case "Revengeful":
            formattedText
                .normal("\(name!),\n\n", font: fontSize)
                .normal("\(userName!) is tired of dealing with your shit. Enough is Enough. You are getting dumped.\n\n", font: fontSize)
            if reason.contains("None") {
                formattedText.normal("\(userName!) has not listed any reasons for breaking up with you. Sucks to suck.\n\n", font: fontSize)
            }
            else if reason.contains("Decline") {
                formattedText.normal("\(userName!) has declined to list the reason for breaking up with you. Sucks to suck.\n\n", font: fontSize)
            }
            else {
                formattedText.normal("This is why you're going to be forever alone:\n\n", font: fontSize)
                for idx in reason.indices {
                    switch reason[idx] {
                    case "Fallen out of love":
                        formattedText.normal("I \(Revengeful.fallen.rawValue).\n\n", font: fontSize)
                    case "He/she cheated on me":
                        formattedText.normal("\(Revengeful.cheated.rawValue) me.\n\n", font: fontSize)
                    case "He/she has changed":
                        formattedText.normal("I \(Revengeful.changed.rawValue).\n\n", font: fontSize)
                    case "Tired of him/her":
                        formattedText.normal("I \(Revengeful.tired.rawValue).\n\n", font: fontSize)
                    case "He/she is crazy":
                        formattedText.normal("I \(Revengeful.crazy.rawValue).\n\n", font: fontSize)
                    case "He/she drinks too much":
                        formattedText.normal("I \(Revengeful.drinker.rawValue).\n\n", font: fontSize)
                    case "He/she is smothering me":
                        formattedText.normal("\(Revengeful.smother.rawValue) me.\n\n", font: fontSize)
                    case "Found someone else":
                        formattedText.normal("I \(Revengeful.found.rawValue).\n\n", font: fontSize)
                    case "Not ready for a relationship":
                        formattedText.normal("I \(Revengeful.notReady.rawValue).\n\n", font: fontSize)
                    case "Need time for self-discovery":
                        formattedText.normal("I \(Revengeful.discover.rawValue).\n\n", font: fontSize)
                    default:
                        formattedText.normal("\(reason[idx]).\n\n", font: fontSize)
                    }
                }
            }
            
            if !more.isEmpty {
                formattedText.normal("Oh by the way, you also suck enough that \(userName!) wants to add:\n\n'\(more!)'.\n\n", font: fontSize)
            }
        default: ()
        }
        
        formattedText.normal("It's Been Great!", font: fontSize)
        
        textView.text = formattedText.string
        textView.font = font!
        textView.backgroundColor = UIColor(red: 0.0/255.0, green: 195.0/255.0, blue: 240.0/255.0, alpha: 1)
    }
    
    @IBAction func rewind(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        if flag == 1 {
            flag = 0
            sender.setImage(UIImage(named: "play"), for: .normal)
        }
        textView.text = formattedText.string
        textView.font = font!
    }
    
    @IBAction func play(_ sender: UIButton) {
        if flag == 0 { // play button
            sender.setImage(UIImage(named: "pause"), for: .normal)
            if !synthesizer.isSpeaking {
                let utterance = AVSpeechUtterance(string: textView.text)
                utterance.rate = defaults.float(forKey: "rate")
                utterance.pitchMultiplier = defaults.float(forKey: "pitch")
                
                if let voiceLanguageCode = defaults.object(forKey: "languageCode") {
                    let voice = AVSpeechSynthesisVoice(language: voiceLanguageCode as? String)
                    utterance.voice = voice
                    print(voice)
                }
                
                synthesizer.speak(utterance)
            }
            else {
                synthesizer.continueSpeaking()
            }
            flag = 1
            // change image
        }
        else if flag == 1 { // pause button
            sender.setImage(UIImage(named: "play"), for: .normal)
            synthesizer.pauseSpeaking(at: .word)
            flag = 0
            //change image
        }
        
    }
    
    @IBAction func stop(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        if flag == 1 {
            flag = 0
            sender.setImage(UIImage(named: "play"), for: .normal)
        }
        textView.text = formattedText.string
        textView.font = font!
    }
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        if check == 0 {
            sender.setImage(UIImage(named: "checkedbox"), for: .normal)
            phoneField.isHidden = false
            check = 1
        }
        else {
            sender.setImage(UIImage(named: "uncheckedbox"), for: .normal)
            phoneField.isHidden = true
            check = 0
        }
    }
    
    
    
    @IBAction func sendSMS(_ sender: UIButton) {
        if (numMessages == 0) || (numMessages < 2 && check == 1) {
            shake(object: sender)
            alert(message: "Please purchase messages first", title: "Alert!")
        }
        else {
            let todosEndpoint: String = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            
            var toNumber = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            switch toNumber.count {
            case 10:
                toNumber = "1" + toNumber
            case 11:
                if String(toNumber.prefix(1)) != "1" {
                    self.alert(message: "Please use this format: (123)-456-7890", title: "Cannot recognize your phone number")
                    return
                }
            default:
                self.alert(message: "Please use this format: (123)-456-7890", title: "Cannot recognize recipient's phone number")
                return
            }
            
            var senderNumber = ""
            if check == 1 {
                senderNumber = phoneField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                switch senderNumber.count {
                case 10:
                    senderNumber = "1" + senderNumber
                case 11:
                    if String(senderNumber.prefix(1)) != "1" {
                        self.alert(message: "Please use this format: (123)-456-7890", title: "Cannot recognize your phone number")
                        return
                    }
                default:
                    self.alert(message: "Please use this format: (123)-456-7890", title: "Cannot recognize your phone number")
                    return
                }
            }
            
            var trimmed = textView.text!.trimmingCharacters(in: CharacterSet.newlines)
            while let rangeToReplace = trimmed.range(of: "\n\n") {
                trimmed.replaceSubrange(rangeToReplace, with: "  ")
            }
            
            print(trimmed)
            
            let data = [
                "To" : toNumber,
                "From" : "+12019891283",
                "Body" : "\(trimmed)"
            ]
            
            print(data["To"])
            
            Alamofire.request(todosEndpoint, method: .post, parameters: data)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    debugPrint(response)
                    
            }
            
            numMessages = numMessages - 1
            defaults.set(numMessages, forKey: "numMessages")
            self.navigationItem.rightBarButtonItem?.title = "Messages: \(numMessages!)"
            
            if check == 1 {
                let data = [
                    "To" : senderNumber,
                    "From" : "+12019891283",
                    "Body" : "\(trimmed)"
                ]
                
                print(data["To"])
                
                Alamofire.request(todosEndpoint, method: .post, parameters: data)
                    .authenticate(user: accountSID, password: authToken)
                    .responseJSON { response in
                        debugPrint(response)
                        
                } 
                
                numMessages = numMessages - 1
                defaults.set(numMessages, forKey: "numMessages")
                self.navigationItem.rightBarButtonItem?.title = "Messages: \(numMessages!)"
            }
         
            alert(message: "Your breakup message has been sent. Now it's officially time to move on!", title: "Congratulations!")
        }
    }
    
    //logic to make sure it is #, and to allow delete
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharCount = textField.text?.count ?? 0
        let newLength = currentCharCount + string.count - range.length
        
        // Target specific textFields by their tags
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
        }
        else {
            switch (newLength) {
            case 1:
                textField.text = "(" + textField.text!
            case 5:
                textField.text = textField.text! + ")-"
            case 10:
                textField.text = textField.text! + "-"
            default: ()
            }
        }
        
        return newLength <= 14
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        mutableAttributedString.addAttribute(.font, value: font!, range: NSMakeRange(0, textView.text.count))
        mutableAttributedString.addAttribute(.font, value: UIFont(name: "Helvetica Neue", size: (Env.iPad ? 36 : 24))!, range: characterRange)
        textView.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: UIColor.black]
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString, attributes: attributes)
        textView.attributedText = mutableAttributedString
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }


}
