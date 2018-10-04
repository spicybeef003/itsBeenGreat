//
//  SettingsViewController.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/29/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit
import AVFoundation

protocol SettingsViewControllerDelegate {
    func didSaveSettings()
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodSlider: UISlider!
    @IBOutlet weak var accentLabel: UILabel!
    @IBOutlet weak var accentField: UITextField!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: SettingsViewControllerDelegate!
    
    var mood: String!
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    var arrVoiceLanguages: [Dictionary<String, String?>] = []
    var speakerNames: [String] = []
    
    var selectedVoiceLanguage = 0
    
    let pickerView = UIPickerView()
    
    var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadToolbar()
        
        accentField.inputView = pickerView
        accentField.inputAccessoryView = toolBar
        accentField.delegate = self
        accentField.font = font!
        accentField.textAlignment = .center
        accentField.tintColor = .clear
        
        mood = defaults.value(forKey: "mood") as! String
        rate = defaults.value(forKey: "rate") as! Float
        pitch = defaults.value(forKey: "pitch") as! Float
        volume = defaults.value(forKey: "volume") as! Float
        
        prepareVoiceList()
        
        editLabel(label: moodLabel, text: "Mood: \(mood!)", font: font!)
        moodSlider.value = Float(moods.index(of: mood)!*100/(moods.count-1))
        
        editLabel(label: accentLabel, text: "Narrator Accent:", font: font!)
        let oldRow = defaults.integer(forKey: "selectedRow")
        let voiceLanguagesDictionary = arrVoiceLanguages[oldRow] as Dictionary<String, String?>
        let speakerName = speakerNames[oldRow]
        accentField.text = speakerName + ", " + voiceLanguagesDictionary["languageName"]!!
        
        editLabel(label: pitchLabel, text: "Speech Pitch: ", font: font!)
        let pitchNoDecimal = String(format: "%.0f", pitch*10 - 5)
        pitchLabel.text = "Speech Pitch: \(pitchNoDecimal)"
        pitchSlider.value = pitch*10
        
        editLabel(label: rateLabel, text: "Speech Rate: ", font: font!)
        let rateNoDecimal = String(format: "%.0f", rate*10)
        rateLabel.text = "Speech Rate: \(rateNoDecimal)"
        rateSlider.value = rate*10
        
        editLabel(label: volumeLabel, text: "Speech Volume: ", font: font!)
        let volumeNoDecimal = String(format: "%.0f", volume*10)
        volumeLabel.text = "Speech Volume: \(volumeNoDecimal)"
        volumeSlider.value = volume*10
        
        editButton(button: saveButton, text: "Save Settings", font: font!)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
            
    }
    
    func prepareVoiceList() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            
            let langName = NSLocale.preferredLanguages[0]
            let locale =  NSLocale(localeIdentifier: voiceLanguageCode)
            let languageName = locale.localizedString(forLanguageCode: langName)!
            
            let dictionary = ["languageName": languageName, "languageCode": voiceLanguageCode]
            
            speakerNames.append(voice.name)
            arrVoiceLanguages.append(dictionary)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        defaults.set(mood, forKey: "mood")
        defaults.set(rate, forKey: "rate")
        defaults.set(pitch, forKey: "pitch")
        defaults.set(volume, forKey: "volume")
        defaults.set(arrVoiceLanguages[selectedVoiceLanguage]["languageCode"]!, forKey: "languageCode")
        defaults.set(selectedVoiceLanguage, forKey: "selectedRow")
        
        self.delegate.didSaveSettings()
        
        navigationController?.popViewController(animated: true)
    }
    
    func loadToolbar() {
        toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.backgroundColor = .white
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
    // MARK: Slider functions
   
    @IBAction func moodChanged(_ sender: UISlider) {
        let step: Float = 100/Float(moods.count-1)
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        mood = moods[Int(round(roundedValue/step))]
        moodLabel.text = "Mood: \(mood!)"
    }
    
    @IBAction func pitchChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        pitch = sender.value/10
        let pitchNoDecimal = String(format: "%.0f", sender.value - 5)
        pitchLabel.text = "Speech Pitch: \(pitchNoDecimal)"
    }
    
    @IBAction func rateChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        rate = roundedValue/10
        let rateNoDecimal = String(format: "%.0f", sender.value)
        rateLabel.text = "Speech Rate: \(rateNoDecimal)"
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        let step: Float = 1
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        volume = roundedValue/10
        let volumeNoDecimal = String(format: "%.0f", sender.value)
        volumeLabel.text = "Speech Volume: \(volumeNoDecimal)"
    }
    
    
    // MARK: UIPickerView method implementation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrVoiceLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let voiceLanguagesDictionary = arrVoiceLanguages[row] as Dictionary<String, String?>
        let speakerName = speakerNames[row]
        
        return (speakerName + ", " + voiceLanguagesDictionary["languageName"]!!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVoiceLanguage = row
        let voiceLanguagesDictionary = arrVoiceLanguages[row] as Dictionary<String, String?>
        let speakerName = speakerNames[row]
        accentField.text = speakerName + ", " + voiceLanguagesDictionary["languageName"]!!
    }
   

}
