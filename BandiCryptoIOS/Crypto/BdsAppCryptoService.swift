import Foundation
import CryptoSwift

public class BdsAppCryptoService {
    private var defaultEncKey = "5zGRgV07gr_s58aMryGJkIDPLZKbW3hAdpWZZXxNuJI"
    //private var defaultEncKey = "gV07g5zGRrDPLZKbW3hAdpWZZXxNuJI+s58aMryGJkI="
    
    private var algoritm = "AES/CBC/PKCS5Padding";
    
    private final var strByteEncoding = "UTF-8";
    
    private var keyValidTime: Int = 300 // 초
    
    public convenience init(seed: String) {
        self.init(seed: seed, keyVaildTime: 300)
    }
    
    public convenience init(keyVaildTime: Int) {
        self.init(seed: "", keyVaildTime: keyVaildTime)
    }
    
    public convenience init(seed: String, keyVaildTime: Int) {
        self.init()
        
        if (seed.trimmingCharacters(in: .whitespaces).count > 5 ) {
            self.defaultEncKey = seed.trimmingCharacters(in: .whitespaces)
        }
        
        if (keyVaildTime > 20) {
            
            self.keyValidTime = keyVaildTime
        }
        
    }
    
    
    public init(defaultEncKey: String = "5zGRgV07gr_s58aMryGJkIDPLZKbW3hAdpWZZXxNuJI", algoritm: String = "AES/CBC/PKCS5Padding", strByteEncoding: String = "UTF-8", keyValidTime: Int = 300) {
        self.defaultEncKey = defaultEncKey
        self.algoritm = algoritm
        self.strByteEncoding = strByteEncoding
        self.keyValidTime = keyValidTime
        
    }
    
    public func encryptTimeKey(data: String, encKey: String? = nil, encoding: String = AppConst.BASE64URL) -> String {
        var keybyte = [UInt8]()
        var keyIv = [UInt8]()
        var hashedKey = [UInt8]()
        
        do {
            defer {
                keybyte.removeAll()
                keyIv.removeAll()
                hashedKey.removeAll()
            }
            
            hashedKey = try getCurrentEncKey(encKey: encKey)
            
            keybyte = Array(hashedKey[0..<32])
            keyIv = Array(hashedKey[hashedKey.count - 16..<32])
            
            let encodedByte = s2b(value: data)
            let encByte = encrypt(sourceBytes: encodedByte, keyBytes: keybyte, ivBytes: keyIv)
            
            return encodeToStr(bytes: encByte, encoding: encoding)
        } catch {
            fatalError("error")
        }
        
    }
    
    public func decryptTimeKey(encData: String, encKey: String? = nil, encoding: String = AppConst.BASE64URL) throws -> String {
        var keybyte = [UInt8]()
        var keyIv = [UInt8]()
        var hashedKey = [UInt8]()
        
        do {
            defer {
                keybyte.removeAll()
                keyIv.removeAll()
                hashedKey.removeAll()
            }
            
            hashedKey = try getCurrentEncKey(encKey: encKey)
            
            keybyte = Array(hashedKey[0..<32])
            keyIv = Array(hashedKey[hashedKey.count - 16..<32])
            
            let decodeByte = try decodeToByte(str: encData, encoding: encoding)
            let decBytes = decrypt(sourceBytes: decodeByte, keyBytes: keybyte, ivBytes: keyIv)
            
            return b2s(bytes: decBytes)
        } catch {
            print(error)
            
            throw CommonErrorCode.CRYPTO_ERROR
        }
        
    }
    
    public func decrypt(sourceBytes: [UInt8], keyBytes: [UInt8], ivBytes: [UInt8]) -> [UInt8] {
        let aes = try! AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs5)
        
        return try! aes.decrypt(sourceBytes)
    }
    
    public func getCurrentEncKey(encKey: String?) throws -> [UInt8] {
        var key = self.defaultEncKey
        
        if let value = encKey {
            key = value
        }
        
        let sourceBytes = s2b(value: key + String(timeBaseKey()))
        // let sourceBytes = s2b(value: key)
        
        return digestMsg(sourceBytes: sourceBytes)
    }
    
    public func timeBaseKey() -> Int {
        
        return Int(NSDate().timeIntervalSince1970) * 1000 / 1000 / self.keyValidTime * self.keyValidTime
    }
    
    public func s2b(value: String) -> [UInt8] {
        
        return Array(value.utf8)
    }
    
    public func b2s(bytes: [UInt8]) -> String {
        return String(bytes: bytes, encoding: .utf8) ?? ""
    }
    
    public func digestMsg(sourceBytes: [UInt8]) -> [UInt8] {
        let data = Data(bytes: sourceBytes, count: sourceBytes.count)
        
        return data.sha256().bytes
    }
    
    public func encrypt(sourceBytes: [UInt8], keyBytes: [UInt8], ivBytes: [UInt8]) -> [UInt8] {
        let aes = try! AES(key: keyBytes, blockMode: CBC(iv: ivBytes), padding: .pkcs5)

        return try! aes.encrypt(sourceBytes)
    }
    
    
    public func encodeToStr(bytes: [UInt8], encoding: String) -> String{
        if (AppConst.HEX == encoding) {
            
            return bytes.toHexString()
        } else if(AppConst.BASE64 == encoding) {
            
            return BdsConverter.toBase64(bytes: bytes, isBase64: true)
        }
        
        return BdsConverter.toBase64(bytes: bytes, isBase64: false)
    }
    
    
    public func decodeToByte(str: String, encoding: String) throws -> [UInt8]{
        if (AppConst.HEX == encoding) {
            
            return BdsConverter.hexToBytes(hexStr: str)
        }
        
        return try BdsConverter.base64ToBytes(base64Str: str)
    }
}
