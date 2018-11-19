//
//  Marshaller.swift
//  bankmidtest
//
//  Created by Junior Lima on 18/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit

class Marshaller: NSObject {
    func Marshall<T : Encodable>(object : T) -> Data {
        let jsonEncoder = JSONEncoder()
        let jsonData =  try! jsonEncoder.encode(object)
        
        let jsonString = String(data: jsonData, encoding: .utf8)

        return jsonData
    }
    
    func Unmarshall<T : Decodable>(data : Data) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let d = try jsonDecoder.decode(T.self, from: data)
            return d
        } catch {
            print(error)
            return nil
        }

    }
}
