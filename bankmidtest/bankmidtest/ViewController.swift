//
//  ViewController.swift
//  bankmidtest
//
//  Created by Junior Lima on 18/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    var timer = Timer()
    
    var proxy = BankProxy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let crypto = Cryptografer()
        
        let key = crypto.stringToBytes("6368616e676520746869732070617373776f726420746f206120736563726574")
        
        let message = "pudim\n"
        
        let encrypted = crypto.encrypt(key: Data(bytes: key!), message: message.data(using: .utf8)!)
        
        let decrypted = crypto.decrypt(key: Data(bytes: key!), cypherText: encrypted!)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            let balance = self.proxy.getBalance("ACC4")
            self.balanceLabel.text = String(format: "%f", balance)
            self.balanceLabel.adjustsFontSizeToFitWidth = true
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

