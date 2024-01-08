

import Foundation

public class BdsAppClient {
    public static let shared = BdsAppClient()
    
    private init() {
    }
    
    var cryptoService = BdsAppCryptoService()
    
    public func urlEncode(value: String, defaultValue: String) -> String {
        
        return value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? defaultValue
    }
    
    public func urlDecode(value: String, defaultValue: String) -> String {
        
        return value.removingPercentEncoding ?? defaultValue
    }
    
    public func jsonEncode(jsonData: [String: Any]) throws -> String {
        let jsonString = try JSONSerialization.data(withJSONObject: jsonData, options: [.withoutEscapingSlashes])
        return String(bytes: jsonString, encoding: .utf8) ?? ""
    }
    
    public func jsonDecode(jsonStr: String) throws -> [String: Any] {
        let result = try JSONSerialization.jsonObject(with: jsonStr.data(using: .utf8)!) as! [String: Any]
        
        return result
    }
    
    public func queryToMap(query: String) -> [String: String] {
        var map = [String: String]()
        
        let decodeQuery = urlDecode(value: query, defaultValue: "")
        
        for pair in (decodeQuery.split(separator: "&")) {
            if let findIdx = pair.firstIndex(of: "=") {
                let name = pair[..<findIdx].trimmingCharacters(in: .whitespaces)
                let value = pair[pair.index(after: findIdx)...].trimmingCharacters(in: .whitespaces)
                
                map[name] = value
            }
        }
        
        return map
    }
    
    public func getRequestString(request: AppRequest) -> String {
        var requestString = ""
        
        if let appHost = request.appHost {
            requestString.append(appHost + "?")
        }
        
        if let clientHostName = request.clientHost {
            requestString.append(AppConst.clientHostName + "=" + clientHostName)
        }
        
        if let requestFnName = request.requestFn {
            requestString.append(AppConst.requestFnName + "=" + requestFnName)
        }
        
        if let serverUrl = request.serverUrl {
            requestString.append(AppConst.serverUrlName + "=" + serverUrl)
        }
        
        if let responseType = request.responseType {
            requestString.append(AppConst.resTypeName + "=" + responseType)
        }
        
        if let userId = request.userId {
            requestString.append(AppConst.userIdName + "=" + userId)
        }
        
        if let customName = request.custom {
            requestString.append(AppConst.customName + "=" + customName)
        }
        
        for (key, value) in request.params {
            requestString.append(key + "=" + value)
        }
        
        return requestString
    }
    
    public func getResult(query: String) -> [String: Any] {
        let queryMap = queryToMap(query: query)
        
        let resType = queryMap[AppConst.resTypeName]
        
        if (resType == AppConst.resTypeEncJson || resType == nil) {
            let encData = queryMap[AppConst.resDataName] ?? ""
            
            do {
                let result = try cryptoService.decryptTimeKey(encData: encData)
                
                var returnMap = try jsonDecode(jsonStr: result)
                
                returnMap.merge(queryMap) { _, value2 in
                    value2
                }
                
                returnMap.removeValue(forKey: AppConst.resDataName)
                
                return returnMap
                
            } catch {
                
                print(error)
            }
            
        } else if (resType == AppConst.resTypeJson) {
            let encData = queryMap[AppConst.resDataName] ?? ""
            
            let result = BdsConverter.base64ToString(base64str: encData)
            
            do {
                var returnMap = try jsonDecode(jsonStr: result)
                
                returnMap.merge(queryMap) { _, value2 in
                    value2
                }
                
                returnMap.removeValue(forKey: AppConst.resDataName)
                
                return returnMap
            } catch {
                
                print(error)
            }
            
        } else if (resType == AppConst.resTypeQuery) {
            return queryMap
        }
        
        return [String: Any]()
    }
    
}
