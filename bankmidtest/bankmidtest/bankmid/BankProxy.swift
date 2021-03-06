//
//  BankProxy.swift
//  bankmidtest
//
//  Created by Junior Lima on 19/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class BankProxy: NSObject {
    var requestor : Requestor
    var host : String = Constants.NamingServerAddress
    var port : Int = Constants.NamingServerPort
    
    init(username : String, password : String) {
        self.requestor = Requestor(host: self.host,
                                   port: self.port,
                                   username: username,
                                   password: password)
    }
    
    func getBalance(_ accountID : String) -> Float {
        let request = requestor.createRequestPacket(methodName: "GetBalance", args: accountID)
        let ret = requestor.invoke(request)
        
        if ret == nil {
            return 0.0
        }
        
        return (ret?.ReturnValue as! Float)
    }
    
    func withdraw(accountID : String, amount : Float) -> String {
        let request = requestor.createRequestPacket(methodName: "Withdraw", args: accountID, amount)
        let ret = requestor.invoke(request)
        
        if ret == nil {
            return "Unsuccessful operation"
        }
        
        return (ret?.ReturnValue as! String)
    }
    
    func deposit(accountID : String, amount : Float) -> String {
        let request = requestor.createRequestPacket(methodName: "Deposit", args: accountID, amount)
        let ret = requestor.invoke(request)
        
        if ret == nil {
            return "Unsuccessful operation"
        }
        
        return (ret?.ReturnValue as! String)
    }
    
    func transfer(payerID : String, payeeID : String, amount : Float) -> String {
        let request = requestor.createRequestPacket(methodName: "Transfer", args: payerID, payeeID, amount)
        let ret = requestor.invoke(request)
        
        if ret == nil {
            return "Unsuccessful operation"
        }
        
        return (ret?.ReturnValue as! String)
    }

}
