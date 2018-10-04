//
//  Extensions.swift
//  TieBreakers
//
//  Created by Jiang, Tony on 12/4/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import QuartzCore

var toolBar: UIToolbar!
let defaults = UserDefaults.standard
let font = UIFont(name: "Helvetica Neue", size: (Env.iPad ? 27 : 18))

let duron = UIColor(red: 199/255, green: 43/255, blue: 80/255, alpha: 1.0)
let mistyrose = UIColor(red: 232/255, green: 173/255, blue: 170/255, alpha: 1)
let verylightgrey = UIColor(red: 232/255, green: 232/255, blue: 238/255, alpha: 1)
let aqua = UIColor(red: 175/255.0, green: 220/255.0, blue: 236/255.0, alpha: 1.0)
let darkGreen = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
    
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var alreadyAdded = Set<Iterator.Element>()
        return self.filter { alreadyAdded.insert($0).inserted }
    }
}

extension String {
    var containsWhitespace : Bool {
        return (self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
    
    var isContainsLetters : Bool{
        let letters = CharacterSet.letters
        return self.rangeOfCharacter(from: letters) != nil
    }
    
    func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
            }.joined(separator: separator))
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func removing(charactersOf string: String) -> String {
        let characterSet = CharacterSet(charactersIn: string)
        let components = self.components(separatedBy: characterSet)
        return components.joined(separator: "")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func shake(object: AnyObject!) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: (object?.center.x)! - 10, y: object.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: object.center.x + 10, y: object.center.y))
        object.layer.add(animation, forKey: "position")
    }
    
    func specialShake(object: AnyObject!) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 20
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: (object?.center.x)! - 20, y: object.center.y + 20))
        animation.toValue = NSValue(cgPoint: CGPoint(x: object.center.x + 20, y: object.center.y - 20))
        object.layer.add(animation, forKey: "position")
    }
    
    func heavyShake(object: AnyObject!) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 20
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: (object?.center.x)! - 50, y: object.center.y + 50))
        animation.toValue = NSValue(cgPoint: CGPoint(x: object.center.x + 50, y: object.center.y - 50))
        object.layer.add(animation, forKey: "position")
    }
    
    func fullRotate(object: AnyObject!) {
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.delegate = self as? CAAnimationDelegate
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 0.4
        fullRotation.repeatCount = 5
        object.layer.add(fullRotation, forKey: "360")
    }
    
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editButton(button: UIButton!, text: String, font: UIFont) {
        button.setTitle(text, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = font
        button.setTitleColor(.white, for: .normal)
        //button.layer.borderColor = UIColor.black.cgColor
        //button.layer.borderWidth = 2
        button.backgroundColor = .purple
        button.layer.cornerRadius = button.frame.height/8
        button.clipsToBounds = true
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping;
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        //view.addSubview(button)
        
    }
    
    func editLabel(label: UILabel!, text: String, font: UIFont) {
        label.text = text
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = font
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byWordWrapping
        //view.addSubview(label)
    }
    
    func editField(field: UITextField!, font: UIFont) {
        field.textAlignment = .center
        field.keyboardType = .default
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = field.frame.height/5
        field.clipsToBounds = true
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.backgroundColor = .clear
        
        //view.addSubview(field)
    }
    
    func editTextView(textView: UITextView, text: String, font: UIFont) {
        textView.text = text
        textView.font = font
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.textColor = UIColor.black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.masksToBounds = false
        
        view.addSubview(textView)
    }
    
    func loadBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setBackgroundColor() {
        view.backgroundColor = UIColor(red: 247.0/255.0, green: 231.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    }
    
    func makeNavTransparent() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func finishedComparing() {
        let myAlert = UIAlertController(title: "Done!", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Show me the final results", style: UIAlertActionStyle.default) { (ACTION) in
            self.performSegue(withIdentifier: "toResults", sender: self)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        var newImage: UIImage
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
            newImage = renderer.image { (context) in
                self.draw(in: rect)
            }
        }
        else {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.draw(in: rect)
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, font: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: font)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String, font: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: font)]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        
        return self
    }
    
    @discardableResult func italics(_ text: String, font: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.italicSystemFont(ofSize: font)]
        let italicsString = NSAttributedString(string: text, attributes: attrs)
        append(italicsString)
        
        return self
    }
    
    @discardableResult func setAsLink(_ textToFind:String, linkURL:String) -> NSMutableAttributedString {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
        }
        return self
    }
        
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

class Env {
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
