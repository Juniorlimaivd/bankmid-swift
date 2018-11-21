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
    var Username : String
    var Password : String
    
    init(name : String, username : String, password : String) {
        self.Name = name
        self.Username = username
        self.Password = password
    }
}

class Service : Codable {
    var Name : String
    var IP : String
    var Port : Int32
}

class Request: Codable {
    var Username : String
    var Data : Data
    
    init(username : String, data : Data) {
        self.Username = username
        self.Data = data
    }
}

class ConsultReturntPkt: Codable {
    var ServiceInfo : Service?
    var Key : String
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
    var username : String
    var password : String
    var crypto = Cryptografer()
    
    init(host : String, port : Int, username : String, password : String) {
        self.host = host
        self.port = port
        self.username = username
        self.password = password
    }
    
    func getServiceInfo(serviceName : String) -> (String, Int, String) {
        let dnsRequester = TCPClientRequestHandler(host: host, port: port)
        dnsRequester.connect()
        
        let data = marshaller.Marshall(object: RequestInfo(name: serviceName,
                                                        username: self.username,
                                                        password: self.password))
        
        let consultPkt = ConsultPkt(consultType: "consult", data: data)
        
        var pkt = marshaller.Marshall(object: consultPkt)
        
        let keyData = crypto.stringToBytes(Constants.DNSKEY)
        
        pkt = crypto.encrypt(key: Data(bytes: keyData!), message: pkt)!
        
        dnsRequester.send(data: pkt)
        
        var retPkt = dnsRequester.receive()
        
        retPkt = crypto.decrypt(key: Data(bytes: keyData!), cypherText: retPkt)!
        
        let returnPkt : ConsultReturntPkt = marshaller.Unmarshall(data: retPkt)!
        
        guard let serviceData = returnPkt.ServiceInfo else {
            return ("", 0, returnPkt.Key)
        }
        
        return (serviceData.IP, Int(serviceData.Port), returnPkt.Key)
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
        var key : String
        (host, port, key) = self.getServiceInfo(serviceName: request.MethodName)
        
        if key == "" {
            print("Autentication failed. Invalid credentials.")
            return nil
        } else if port < 100 {
            print("Service not found.")
            return nil
        }
        
        print(host)
        print(port)
        
        if host == "" {host = "localhost"}
        
        self.requestHandler = TCPClientRequestHandler(host: host, port: port)
        self.requestHandler!.connect()
        
        var data = self.marshaller.Marshall(object: request)
        let keyData = crypto.stringToBytes(key)
        
        let encryptedData = crypto.encrypt(key: Data(bytes: keyData!), message: data)
        
        if encryptedData == nil {
            print("Failed encrypting.")
            return nil
        }
        
        let request = Request(username: self.username, data: encryptedData!)
        
        data = self.marshaller.Marshall(object: request)
        
        self.requestHandler?.send(data: data)
        
        let ret = self.requestHandler?.receive()
        
        guard let dat = ret else {
            print("Invalid received packet. Verify your requisition.")
            return nil
        }
        
        let decrypt = self.crypto.decrypt(key: Data(bytes: keyData!), cypherText: dat)
        
        guard let pkt = decrypt else {
            print("Failed Decrypting.")
            return nil
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: pkt, options: []) as? [String: Any] else {
            // appropriate error handling
            print("error")
            return nil
        }
        
        return ReturnPkt(methodName: json!["MethodName"] as! String, returnValue: json!["ReturnValue"], error: json!["Err"] as? Error)
        
    }
}
