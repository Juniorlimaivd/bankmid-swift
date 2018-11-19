//
//  ViewController.swift
//  bankmidtest
//
//  Created by Junior Lima on 18/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestor = Requestor()
        
        let request = requestor.createRequestPacket(methodName: "Transfer", args: "ACC4", "ACC2", 50.0)
        let ret = requestor.invoke(request)
        
        //print(ret)
        
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

