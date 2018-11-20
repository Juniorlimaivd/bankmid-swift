//
//  Cryptografer.swift
//  bankmidtest
//
//  Created by Junior Lima on 19/11/18.
//  Copyright © 2018 Junior Lima. All rights reserved.
//

import UIKit
import CryptoSwift

class Cryptografer: NSObject {
    
    func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.characters.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
    func generateRandomBytes() -> Data? {
        
        var keyData = Data(count: 12)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, 12, $0)
        }
        if result == errSecSuccess {
            return keyData
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
    
    func encrypt(key : Data, message : Data) -> Data?  {
        
        let iv = self.generateRandomBytes()
        let ivarray = [UInt8](iv!)
        let keyarray = [UInt8](key)
        let messagearray = [UInt8](message)
        do {
            // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: ivarray, mode: .combined)
            let aes = try AES(key: keyarray, blockMode: gcm, padding: .noPadding)
            var encrypted = try aes.encrypt(messagearray)
            encrypted = ivarray + encrypted
            return Data(bytes: encrypted)
        } catch {
            print(error)
            return nil
            // failed
        }
        
        
    }
    
    func decrypt(key : Data, cypherText : Data) -> Data? {
        var cypherTextArray = [UInt8](cypherText)
        let ivarray = Array(cypherTextArray.prefix(12))
        cypherTextArray = Array(cypherTextArray.suffix(from: 12))
        let keyarray = [UInt8](key)
        do {
            // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: ivarray, mode: .combined)
            let aes = try AES(key: keyarray, blockMode: gcm, padding: .noPadding)
            let byt = try aes.decrypt(cypherTextArray)
            return Data(bytes: byt)
        } catch {
            print(error)
            return nil
            // failed
        }
    }
}
