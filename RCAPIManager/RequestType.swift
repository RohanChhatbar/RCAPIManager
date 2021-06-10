//
//  RequestType.swift
//  RCAPIManager
//
//  Created by Rohan on 10/06/21.
//

import Foundation
import Alamofire

public typealias JSON = [String:Any]
public typealias HeaderJSON = [String:String]

public struct RequestType {
    
    public let url : String
    public let method : HTTPMethod
    public var parameters : JSON? = nil
    public var headers : HeaderJSON? = nil
    
    public init(url:String,method : HTTPMethod,parameters : JSON? = nil,headers : HeaderJSON? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}

public func asURLReqeust(type:RequestType) -> URLRequest? {
    let url = URL(string: type.url)!
    var request = URLRequest(url: url)
    request.httpMethod = type.method.rawValue
    
    if let parameters = type.parameters {
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            RCPrint("Error in Paramter Serialization ",error.localizedDescription)
            return nil
        }
    }
    
    if let headers = type.headers {
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return request
}
