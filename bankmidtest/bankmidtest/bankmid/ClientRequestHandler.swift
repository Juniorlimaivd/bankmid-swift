//
//  ClientRequestHandler.swift
//  bankmidtest
//
//  Created by Junior Lima on 18/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit
import SwiftSocket


protocol ClientRequestHandler {
    func connect()
    func send(data : Data)
    func receive() -> Data
    func close()
}

class TCPClientRequestHandler: ClientRequestHandler {
    var host : String
    var port : Int
    var client : TCPClient
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        self.client = TCPClient(address: host, port: Int32(port))
    }
    
    func connect() {
        switch self.client.connect(timeout: 3) {
        case .failure(let error):
            print(error.localizedDescription)
        case .success:
            print("show")
        }
    }
    
    func send(data: Data) {
        switch self.client.send(data: data) {
        case .failure(let error):
            print(error.localizedDescription)
        case .success:
            print("success sending")
        }
    }
    
    func receive() -> Data {
        
        var data : [Byte]? = nil
            
        while data == nil {
            data = self.client.read(1024*10, timeout: 10)
        }

        return Data(bytes: data!)
    }
    
    func close() {
        self.client.close()
    }
    
    
}
