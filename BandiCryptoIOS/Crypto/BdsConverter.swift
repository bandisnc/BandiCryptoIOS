//
//  BdsConverter.swift
//  bandiCryptoLibrary
//
//  Created by bandisnc on 2023/12/22.
//

import Foundation
import CryptoSwift

public class BdsConverter {
    public static let UTF_8 = String.Encoding.utf8
    
    public static func s2b(source: String) -> [UInt8] {
        
       return Array(source.utf8)
    }
       
    public static func b2s(bytes: [UInt8]) -> String {
       
       return String(bytes: bytes, encoding: UTF_8)!
    }
    
    public static func toBase64(bytes: [UInt8], isBase64: Bool) -> String{
        if (isBase64) {
            return Data(bytes).base64EncodedString()
        }
        
        return base64ToBase64url(base64: Data(bytes).base64EncodedString())
    }
    
    public static func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    
    public static func hexToStr(text: String) -> String {

      let regex = try! NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive)
      let textNS = text as NSString
      let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
          
      let characters = matchesArray.map {
          Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: 2)), radix: 16)!)!)
      }

      return String(characters)
    }
    
    public static func hexToBytes(hexStr: String) -> [UInt8] {
        
        return Data(hex: hexStr).bytes
    }
    
    public static func base64ToBytes(base64Str: String) throws -> [UInt8] {
        
        let str = base64Str.replacingOccurrences(of: "\"", with: "")
        
        let convertString = base64urlToBase64(base64url: str)
        
        return try decodeBase64(msg: convertString)
                
    }
    
    public static func decodeBase64(msg: String) throws -> [UInt8] {
        guard let data = Data(base64Encoded: msg) else {
            throw CommonErrorCode.DATA_IS_NULL
        }
        
        return data.bytes
    }
    
    
    public static func base64urlToBase64(base64url: String) -> String {
        var base64 = base64url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        
        return base64
    }
       
    public static func base64ToString(base64str: String) -> String {
        
        do {
            
            let result = try b2s(bytes: base64ToBytes(base64Str: base64str))
            
            return result
        } catch {
            print(error)
        }
        
        return ""
    }

    
}
