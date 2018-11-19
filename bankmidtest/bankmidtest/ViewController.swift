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
        

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            let balance = self.proxy.getBalance("ACC4")
            self.balanceLabel.text = String(format: "%.2f", balance)
            self.balanceLabel.adjustsFontSizeToFitWidth = true
        })
        
        
//        print(ret)
//
//        let requestHandler = TCPClientRequestHandler()
//        requestHandler.connect()
//        switch requestHandler.client.send(string: "olar") {
//        case .failure(let error):
//            print(error.localizedDescription)
//        case .success:
//            print("show")
//        }
//        let data = Data(base64Encoded: "ola")
//        requestHandler.send(data: data!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

