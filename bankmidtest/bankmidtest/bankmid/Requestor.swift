//
//  Requestor.swift
//  bankmidtest
//
//  Created by Junior Lima on 18/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class ConsultPkt : Codable {
    var ConsultType : String
    var Data : Data
    
    init(consultType : String, data : Data) {
        self.Data = data
        self.ConsultType = consultType
    }
}

class RequestInfo : Codable {
    var Name : String
    
    init(name : String) {
        self.Name = name
    }
}

class Service : Codable {
    var Name : String
    var IP : String
    var Port : Int32
}

class Requestor: NSObject {
    let marshaller = Marshaller()
    let requestHandler : TCPClientRequestHandler? = nil
    
    func getServiceInfo(serviceName : String) -> (String, Int) {
        let dnsRequester = TCPClientRequestHandler(host: "localhost", port: 5555)
        dnsRequester.connect()
        
        let d = marshaller.Marshall(object: RequestInfo(name: serviceName))
        
        let consultPkt = ConsultPkt(consultType: "consult", data: d)
        
        let pkt = marshaller.Marshall(object: consultPkt)
        
        dnsRequester.send(data: pkt)
        
        
        
        let retPkt = dnsRequester.receive()
        
        let serviceData : Service = marshaller.Unmarshall(data: retPkt)!
        
        return (serviceData.IP, Int(serviceData.Port))
    }
    
    func invoke() {
        var host : String
        var port : Int
        (host, port) = self.getServiceInfo(serviceName: "GetBalance")
        
        print(host)
        print(port)
    }
}
