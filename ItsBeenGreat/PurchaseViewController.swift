//
//  PurchaseViewController.swift
//  ItsBeenGreat
//
//  Created by Jiang, Tony on 12/28/17.
//  Copyright © 2017 Jiang, Tony. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var queryRunning: Int = 0
    
    let purchases = ["1 Breakup (1 Message) for $0.99",
                     "3 Breakups (3 Messages) for $1.99",
                     "5 Breakups (5 Messages) for $2.99",
                     "10 Breakups (10 Messages) for $3.99"]
    
    let purchaseLabels = ["Beginner","Intermediate","Advanced","Pro"]
    
    var selectedIndexPath: [IndexPath] = []
    
    let bundleID = "com.TianProductions"
    let buy1ID = "com.TianProductions.buy1"
    let buy3ID = "com.TianProductions.buy3"
    let buy5ID = "com.TianProductions.buy5"
    let buy10ID = "com.TianProductions.buy10"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var numMessages = defaults.integer(forKey: "numMessages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editLabel(label: instructionLabel, text: "Select the package that best fits your needs", font: font!)
        instructionLabel.textAlignment = .center
        
        editButton(button: purchaseButton, text: "Purchase", font: font!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        SKPaymentQueue.default().add(self)
        
        fetchAvailableProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SKPaymentQueue.default().remove(self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return purchaseLabels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        cell.textLabel?.text = purchases[indexPath.section]
        cell.textLabel?.font = font!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return purchaseLabels[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delayInSeconds = 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds * 1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                selectedIndexPath.remove(at: selectedIndexPath.index(of: indexPath)!)
                print(selectedIndexPath)
            }
            else {
                cell.accessoryType = .checkmark
                if !selectedIndexPath.isEmpty {
                    let oldCell = tableView.cellForRow(at: selectedIndexPath[0])
                    oldCell?.accessoryType = .none
                    selectedIndexPath.remove(at: 0)
                }
                selectedIndexPath.insert(indexPath, at: 0)
                print(selectedIndexPath)
            }
        }
        
        
    }
    
    @IBAction func purchase(_ sender: UIButton) {
        if selectedIndexPath.isEmpty {
            alert(message: "", title: "Please select a package plan")
        }
        else {
            self.networkSpinner(1)
            let indexSection = selectedIndexPath[0].section
            purchaseMyProduct(product: iapProducts[indexSection])
        }
    }
    

}

extension PurchaseViewController {
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        productsRequest.cancel()
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
                                        buy1ID,
                                        buy3ID,
                                        buy5ID,
                                        buy10ID
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products.sorted(by: { (p0, p1) -> Bool in
                return p0.price.floatValue < p1.price.floatValue
            })
        }
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
            
            // IAP Purchases disabled on the Device
        } else {
            alert(message: "Purchases are disabled in your device!", title: "Error")
        }
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    switch productID {
                    case buy1ID:
                        numMessages = numMessages + 1
                    case buy3ID:
                        numMessages = numMessages + 3
                    case buy5ID:
                        numMessages = numMessages + 5
                    case buy10ID:
                        numMessages = numMessages + 10
                    default: ()
                    }
                    
                    DispatchQueue.main.async {
                        defaults.set(self.numMessages, forKey: "numMessages")
                        self.alert(message: "You currently have \(self.numMessages) Messages/Breakups" as NSString, title: "Congratulations!")
                        self.networkSpinner(-1)
                    }
                    print("purchased")
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    DispatchQueue.main.async {
                        self.networkSpinner(-1)
                    }
                    print("failed")
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    DispatchQueue.main.async {
                        self.networkSpinner(-1)
                    }
                    print("restored")
                    break
                default: break
                }
            }
        }
    }
    
    // MARK:-restore purchase
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            default:
               ()
            }
        }
    }
    
    
    
    func networkSpinner(_ adjust: Int) {
        DispatchQueue.main.async {
            self.queryRunning = self.queryRunning + adjust
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.queryRunning > 0
        }
    }
}


