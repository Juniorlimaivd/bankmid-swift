//
//  ViewController.swift
//  bankmidtest
//
//  Created by Junior Lima on 18/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var accIDLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    var timer = Timer()
    
    @IBOutlet weak var operationSegment: UISegmentedControl!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var performActionButton: UIButton!
    var username : String? = nil
    var password : String? = nil
    
    var proxy : BankProxy? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.accIDLabel.text = username!
        self.proxy = BankProxy(username: self.username!, password: self.password!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            let balance = self.proxy!.getBalance(self.username!)
            self.balanceLabel.text = String(format: "%.2f", balance)
            self.balanceLabel.adjustsFontSizeToFitWidth = true
        })
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didChangedSegmented(_ sender: Any) {
        
    }
    
    @IBAction func didTappedToPerform(_ sender: Any) {
        switch self.operationSegment.selectedSegmentIndex {
        case 0:
            if self.accountTextField.text == "" || self.valueTextField.text == "" {
                let alert = UIAlertController(title: "Error", message: "Por favor forneça conta e valor.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                return
            }
            
            let result = self.proxy?.transfer(payerID: self.username!, payeeID: self.accountTextField.text!, amount: Float(self.valueTextField.text!)!)
            
            let alert = UIAlertController(title: "Result", message: result, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            break
            
        
            
        case 1:
            if self.valueTextField.text == "" {
                let alert = UIAlertController(title: "Error", message: "Por favor forneça valor.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                return
            }
            
            let result = self.proxy?.deposit(accountID: self.username!, amount: Float(self.valueTextField.text!)!)
            
            let alert = UIAlertController(title: "Result", message: result, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            break
            
        case 2:
            if self.valueTextField.text == "" {
                let alert = UIAlertController(title: "Error", message: "Por favor forneça valor.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                return
            }
            
            let result = self.proxy?.withdraw(accountID: self.username!, amount: Float(self.valueTextField.text!)!)
            
            let alert = UIAlertController(title: "Result", message: result, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            break
        default:
            break
        }
    }
    
}

