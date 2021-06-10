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

public func asURLReqeust(request:RequestType) -> URLRequest? {
    let url = URL(string: request.url)!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    
    if let parameters = request.parameters {
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            RCPrint("Error in Paramter Serialization ",error.localizedDescription)
            return nil
        }
    }
    
    if let headers = request.headers {
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
    
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return urlRequest
}

