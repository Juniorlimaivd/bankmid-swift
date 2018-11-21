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


}

