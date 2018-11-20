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
    
    var proxy = BankProxy(username: "ACC4", password: "pudim")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

