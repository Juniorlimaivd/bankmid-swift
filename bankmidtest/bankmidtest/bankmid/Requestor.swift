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

extension Encodable {
    fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}

struct AnyEncodable : Encodable {
    var value: Encodable
    init(_ value: Encodable) {
        self.value = value
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
}

class ReturnPkt {
    var MethodName : String
    var ReturnValue : Any
    var Error : Error?

    init(methodName : String, returnValue : Any, error : Error?) {
        self.MethodName = methodName
        self.ReturnValue = returnValue
        self.Error = error
    }
}

class RequestPkt : Encodable {
    var MethodName : String
    var Args : [AnyEncodable]
    
    init(methodName : String, args : [AnyEncodable]) {
        self.MethodName = methodName
        self.Args = args
    }
}

class Requestor: NSObject {
    let marshaller = Marshaller()
    var requestHandler : TCPClientRequestHandler? = nil
    var host : String
    var port : Int
    
    init(host : String, port : Int) {
        self.host = host
        self.port = port
    }
    
    func getServiceInfo(serviceName : String) -> (String, Int) {
        let dnsRequester = TCPClientRequestHandler(host: host, port: port)
        dnsRequester.connect()
        
        let d = marshaller.Marshall(object: RequestInfo(name: serviceName))
        
        let consultPkt = ConsultPkt(consultType: "consult", data: d)
        
        let pkt = marshaller.Marshall(object: consultPkt)
        
        dnsRequester.send(data: pkt)
        
        let retPkt = dnsRequester.receive()
        
        let serviceData : Service = marshaller.Unmarshall(data: retPkt)!
        
        return (serviceData.IP, Int(serviceData.Port))
    }
    
    
    func createRequestPacket(methodName : String, args : Codable ...) -> RequestPkt {
        var parameters : [AnyEncodable] = []
        
        for arg in args {
            parameters.append(AnyEncodable(arg))
        }
        
        return RequestPkt(methodName: methodName, args: parameters)
    }
    
    func invoke(_ request : RequestPkt) -> ReturnPkt? {
        var host : String
        var port : Int
        (host, port) = self.getServiceInfo(serviceName: request.MethodName)
        
        print(host)
        print(port)
        
        if host == "" {host = "localhost"}
        
        self.requestHandler = TCPClientRequestHandler(host: host, port: port)
        self.requestHandler!.connect()
        
        let data = self.marshaller.Marshall(object: request)
        
        self.requestHandler?.send(data: data)
        
        let ret = self.requestHandler?.receive()
        
        let dat = ret!
        
        guard let json = try? JSONSerialization.jsonObject(with: dat, options: []) as? [String: Any] else {
            // appropriate error handling
            print("error")
            return nil
        }
        
        return ReturnPkt(methodName: json!["MethodName"] as! String, returnValue: json!["ReturnValue"], error: json!["Err"] as? Error)
        
    }
}
