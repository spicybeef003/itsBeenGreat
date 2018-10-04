//
//  ViewController.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/12/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit
import Eureka
import MessageUI
import AVFoundation
import JFContactsPicker

class EnterInfoViewController: FormViewController, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, SettingsViewControllerDelegate, ContactsPickerDelegate {
    
    @IBOutlet weak var progImage: UIImageView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var FAQbutton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var previewMessageButton: UIButton!
    
    var userName: String = ""
    var name: String = ""
    var phone: String = ""
    var reason: Set<String>!
    var other: String = ""
    var more: String = ""

    var userNameOK = false
    var nameOK = false
    var phoneOK = false
    var reasonOK = false
    
    var mood: String!
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    var preferredVoiceLanguageCode: String!
    var numMessages: Int!
    
    var recipientNumber: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        self.navigationItem.rightBarButtonItem?.title = "Messages: \(numMessages!)"
        
        tableView.flashScrollIndicators()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = verylightgrey
        //tableView.backgroundColor = mistyrose
        //tableView.separatorColor = .white
        tableView.separatorStyle = .none
        
        editButton(button: purchaseButton, text: "Purchase Messages", font: font!)
        editButton(button: FAQbutton, text: "FAQs", font: font!)
        editButton(button: settingsButton, text: "Settings", font: font!)
        editButton(button: previewMessageButton, text: "Preview Message", font: font!)
        previewMessageButton.backgroundColor = darkGreen
        
        // background image
        
        TextRow.defaultCellSetup = { cell, row in
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            cell.backgroundColor = .clear
        }
        
        TextAreaRow.defaultCellSetup = { cell, row in
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .clear
        }
        
        MultipleSelectorRow<String>.defaultCellSetup = { cell, row in
            cell.separatorInset = UIEdgeInsets.zero
            cell.backgroundColor = .clear
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        
        PhoneRow.defaultCellSetup = { cell, row in
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .clear
        }
        
        ButtonRow.defaultCellSetup = { cell, row in
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.backgroundColor = .clear
        }
        
        LabelRow.defaultCellSetup = { cell, row in
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            cell.backgroundColor = mistyrose
        }
        
        tableView.frame = CGRect(x: tableView.frame.minX, y: self.navigationController!.navigationBar.frame.height + 20, width: tableView.frame.width, height: (view.frame.height*0.6 > previewMessageButton.frame.minY - self.navigationController!.navigationBar.frame.height - 36 ? previewMessageButton.frame.minY - self.navigationController!.navigationBar.frame.height - 36 : view.frame.height*0.6))
        
        self.view.bringSubview(toFront: previewMessageButton)
        
        form
            +++ Section() { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { 60.0 }
                header.onSetupView = { (view,_) in
                    view.textColor = .black
                    view.textAlignment = .center
                    view.text = "Your Information"
                    view.font = UIFont.boldSystemFont(ofSize: 20)
                    view.backgroundColor = .white
                }
                section.header = header
            }
            
            <<< TextRow("senderName") { row in
                row.title = "Your Name"
                row.placeholder = "Enter name here"
                //row.placeholderColor = .white
                } .cellSetup { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.font = font!
                    cell.textField.autocorrectionType = .no
                } .onCellHighlightChanged { cell, row in
                    if !row.isHighlighted {
                        if let _ = row.value {
                            row.value = row.value
                        }
                    }
            }
            
            
            +++ Section() { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { 60.0 }
                header.onSetupView = { (view,_) in
                    view.textColor = .black
                    view.textAlignment = .center
                    view.numberOfLines = 2
                    view.text = "Contact Information For Person Getting Dumped"
                    view.font = UIFont.boldSystemFont(ofSize: 20)
                    view.backgroundColor = .white
                }
                section.header = header
            }
            
            <<< ButtonRow("contact") { row in
                row.title = "Choose from Contacts"
                } .cellUpdate({ (cell, row) in
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                }) .onCellSelection { (cell, row) in
                    let contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.phoneNumber)
                    let navigationController = UINavigationController(rootViewController: contactPickerScene)
                    self.present(navigationController, animated: true, completion: nil)
            }
            
            <<< LabelRow(){
                $0.title = "OR fill out below"
                $0.cellStyle = .default
                } .cellUpdate({ (cell, row) in
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                })
            
            <<< TextRow("name") { row in
                row.title = "Recipient's Name"
                row.placeholder = "Enter name here"
                //row.placeholderColor = .white
                } .cellSetup { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.font = font!
                    cell.textField.autocorrectionType = .no
                } .onCellHighlightChanged { cell, row in
                    if !row.isHighlighted {
                        if let _ = row.value {
                            row.value = row.value
                        }
                    }
            }
            
            <<< PhoneRow("phone") { row in
                row.title = "Recipient's Phone Number"
                row.placeholder = "(123)-456-7890"
                //row.placeholderColor = .white
                } .cellSetup { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.font = font!
                } .cellUpdate{ cell, row in
                    cell.textField.delegate = self
                    cell.textField.tag = 100  // allows specific textfield targeting
            }
            
            +++ Section() { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { 60.0 }
                header.onSetupView = { (view,_) in
                    view.textColor = .black
                    view.textAlignment = .center
                    view.numberOfLines = 1
                    view.text = "Additional Thoughts"
                    view.font = UIFont.boldSystemFont(ofSize: 20)
                    view.backgroundColor = .white
                }
                section.header = header
            }
            
            <<< MultipleSelectorRow<String>("reason") {
                $0.title = "Reason For Breakup"
                $0.selectorTitle = "Select all that apply"
                $0.options = ["Fallen out of love",
                              "He/she cheated on me",
                              "He/she has changed",
                              "Tired of him/her",
                              "He/she is crazy",
                              "He/she drinks too much",
                              "He/she is smothering me",
                              "Found someone else",
                              "Not ready for a relationship",
                              "Need time for self-discovery",
                              "Relationship doesn't feel right",
                              "It's not you it's me",
                              "Meh...",
                              "I love you, but i'm not IN love with you",
                              "Other",
                              "None",
                              "Decline"]
                
                
                
                } .onPresent { form, selectorController in
                } .onChange { row in
                    if let values = row.value {
                        if values.count > 1 && values.contains("None") {
                            row.value?.remove("None")
                        }
                        else if values.count == 0 {
                            row.value = ["None"]
                        }
                    }
                } .cellSetup { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.font = font!
                } .onCellHighlightChanged { cell, row in
                    if !row.isHighlighted {
                        if let _ = row.value {
                            self.reasonOK = true
                        }
                    }
                } .cellUpdate { cell, row in
                    if (row.value != nil) {
                        cell.detailTextLabel?.text =  row.value!.joined(separator: ", ")
                    }
            }
            
            <<< TextAreaRow("other"){
                $0.hidden = Condition.function(["reason"], { form in
                    let multiRow = form.rowBy(tag: "reason") as! MultipleSelectorRow<String>
                    if let _ = multiRow.value {
                        return multiRow.value!.contains("Other") ? false : true
                    }
                    return true
                })
                $0.placeholder = "OPTIONAL: State 'other' reason for the breakup here"
                } .cellSetup { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.font = font!
                    cell.textView.backgroundColor = .clear
            }
           
            <<< TextAreaRow("more") {
                $0.placeholder = "OPTIONAL: Add any other thoughts you would like to say."
                } .cellSetup { cell, row in
                    cell.backgroundColor = UIColor.clear
                    cell.textLabel?.font = font!
                    cell.textView.backgroundColor = .clear
            }
        //tableView.reloadData()
        
    }
    
    @IBAction func previewMessage(_ sender: UIButton) {
        let valuesDictionary = self.form.values()
        
        if valuesDictionary["senderName"] as? String == nil {
            self.userNameOK = false
        }
        else {
            self.userNameOK = true
            self.userName = valuesDictionary["senderName"] as! String
        }
        
        if valuesDictionary["name"] as? String == nil {
            self.nameOK = false
        }
        else {
            self.nameOK = true
            self.name = valuesDictionary["name"] as! String
        }
        
        if valuesDictionary["phone"] as? String == nil {
            self.phoneOK = false
        }
        else if !validateNumber(phone: valuesDictionary["phone"] as! String) {
            self.phoneOK = false
        }
        else {
            self.phoneOK = true
            self.phone = valuesDictionary["phone"] as! String
        }
        
        if (valuesDictionary["reason"] as? Set<String>) == nil {
            self.reasonOK = false
        }
        else {
            self.reasonOK = true
            self.reason = valuesDictionary["reason"] as! Set<String>
        }
        
        if valuesDictionary["more"] as? String != nil {
            self.more = valuesDictionary["more"] as! String
        }
        
        if valuesDictionary["other"] as? String != nil {
            self.other = valuesDictionary["more"] as! String
        }
        
        switch (self.userNameOK, self.nameOK, self.phoneOK, self.reasonOK) {
        case (false,_,_,_):
            self.alert(message: "", title: "Please enter your name to reinforce the validity of your message")
        case (_,false, _, _):
            self.alert(message: "", title: "Please enter the recipient's name")
        case (_,_,false, _):
            self.alert(message: "Format: (123)-456-7890", title: "Please enter the recipient's phone number")
        case (_,_,_, false):
            self.alert(message: "Select 'None' if you cannot think of a reason, or 'Decline' if you do not want to add a reason", title: "Please enter the reason for breakup.")
        case (true, true, true, true):
            self.performSegue(withIdentifier: "toForm", sender: self)
        default: ()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.flashScrollIndicators()
    }
    
    //logic to make sure it is #, and to allow delete
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharCount = textField.text?.count ?? 0
        let newLength = currentCharCount + string.count - range.length
        
        // Target specific textFields by their tags
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (textField.tag == 100) {
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
        }
        return newLength <= 14
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 100) {
            textField.text = ""
        }
    }
    
    @IBAction func purchase(_ sender: UIButton) {
        
    }
    
    @IBAction func faq(_ sender: UIButton) {
        
    }
    
    func validateNumber(phone: String) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let numberOfMatches = detector.numberOfMatches(in: phone, range: NSMakeRange(0, phone.count))
            
            let matches = detector.matches(in: phone, options: [], range: NSRange(location: 0, length: phone.count))
            var resultsArray = [String]()
            
            for match in matches {
                if match.resultType == .phoneNumber,
                    let component = match.phoneNumber {
                    resultsArray.append(component)
                }
            }
            print(resultsArray)
            return numberOfMatches > 0
        }
        catch {
            print(error)
        }
        return false
    }
    
    
    @IBAction func contact(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            self.alert(message: "Mail services are not available", title: "")
            return
        }
        else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["Bryan.Maliken@gmail.com"])
            composeVC.setSubject("")
            composeVC.setMessageBody("", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func didSaveSettings() {
        mood = defaults.value(forKey: "mood") as! String
        rate = defaults.value(forKey: "rate") as! Float
        pitch = defaults.value(forKey: "pitch") as! Float
        volume = defaults.value(forKey: "volume") as! Float
        
        preferredVoiceLanguageCode = defaults.object(forKey: "languageCode") as! String
    }
    
    func registerDefaultSettings() {
        mood = moods[0]
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        numMessages = 1 // try to give 1
        
        defaults.set(mood, forKey: "mood")
        defaults.set(rate, forKey: "rate")
        defaults.set(pitch, forKey: "pitch")
        defaults.set(volume, forKey: "volume")
        defaults.set(Int(8), forKey: "selectedRow")
        defaults.set(numMessages, forKey: "numMessages")
    }
    
    func loadSettings() -> Bool {
        if let theRate: Float = defaults.value(forKey: "rate") as? Float {
            mood = defaults.value(forKey: "mood") as! String
            rate = theRate
            pitch = defaults.value(forKey: "pitch") as! Float
            volume = defaults.value(forKey: "volume") as! Float
            numMessages = defaults.integer(forKey: "numMessages")
            return true
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toForm" {
            let destination = segue.destination as! FinalMessageViewController
            destination.userName = userName
            destination.name = name
            destination.phone = phone
            destination.reason = reason
            destination.more = more
            destination.other = other
        }
        
        if segue.identifier == "toSettings" {
            let destination = segue.destination as! SettingsViewController
            destination.delegate = self
        }
    }
    
   

}

extension EnterInfoViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: EPContactsPicker delegates
    func contactPicker(_: ContactsPicker, didSelectContact contact: Contact)
    {
        print("Name: \(contact.displayName) Number: \(contact.phoneNumbers[0].0) has been selected")
        let nameRow = self.form.rowBy(tag: "name") as! TextRow
        nameRow.value = contact.displayName
        let numberRow = self.form.rowBy(tag: "phone") as! PhoneRow
        numberRow.value = contact.phoneNumbers[0].0
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_: ContactsPicker, didCancel error: NSError)
    {
        print("User canceled the selection");
        self.dismiss(animated: true, completion: nil)
    }
    
}

