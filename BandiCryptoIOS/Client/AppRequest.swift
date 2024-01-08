import Foundation

public class AppRequest {
    private(set) var appHost: String?
    private(set) var clientHost: String?
    private(set) var requestFn: String?
    private(set) var serverUrl: String?
    private(set) var responseType: String?
    private(set) var userId: String?
    private(set) var custom: String?
    private(set) var params = [String: String]()
    
    public static func builder() -> Builder {
        return Builder()
    }
    
    
    init(builder: Builder) {
        self.appHost = builder.appHost
        self.clientHost = builder.clientHost
        self.requestFn = builder.requestFn
        self.serverUrl = builder.serverUrl
        self.responseType = builder.responseType
        self.userId = builder.userId
        self.custom = builder.custom
        self.params = builder.params
    }
    
    public class Builder {
        private(set) var appHost: String?
        private(set) var clientHost: String?
        private(set) var requestFn: String?
        private(set) var serverUrl: String?
        private(set) var responseType: String?
        private(set) var userId: String?
        private(set) var custom: String?
        private(set) var params = [String: String]()
        
        public func appHost(_ appHost: String) -> Self {
            self.appHost = appHost
            
            return self
        }
        
        public func clientHost(_ clientHost: String) -> Self {
            self.clientHost = clientHost
            
            return self
        }
        
        public func requestFn(_ requestFn: String) -> Self {
            self.requestFn = requestFn
            
            return self
        }
        
        public func serverUrl(_ serverUrl: String) -> Self {
            self.serverUrl = serverUrl
            
            return self
        }
        
        public func responseType(_ responseType: String) -> Self {
            self.responseType = responseType
            
            return self
        }
        
        public func userId(_ userId: String) -> Self {
            self.userId = userId
            
            return self
        }
        
        public func custom(_ custom: String) -> Self {
            self.custom = custom
            
            return self
        }
        
        public func params(_ params: [String: String]) -> Self {
            
            for (key, value) in params {
                self.params[key] = value
            }
       
            return self
        }

        
        public func build() -> AppRequest {
            return AppRequest(builder: self)
        }
    }
    
}
