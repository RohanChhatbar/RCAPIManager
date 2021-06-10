//
//  ViewController.swift
//  Example
//
//  Created by Rohan on 10/06/21.
//

import UIKit
import RCAPIManager

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRequest()
    }
    
    func getRequest() {
        
        if let request = try? URLRequest(url: "https://reqres.in/api/users?page=1", method: .get) {
            APIManager.shared.requestJSON(model: UserListDataModel.self, convertible: request) { (responseModel) in
                //Here Return UserListDataModel
                
                if let users = responseModel.data {
                    _ = users.map({RCPrint("User email ",$0.email)})
                }
                
                RCPrint("Total Page count ",responseModel.total_pages)
            }
        }
        
    }
    
    func postRequest() {
        
        let params = [
            "name":"Rohan",
            "job":"IOS Developer"
        ]
        
        if let request = try? URLRequest(url: "https://reqres.in/api/users", method: .post) {
            
            APIManager.shared.requestJSON(model: <#T##(Decodable & Encodable).Protocol#>, convertible: <#T##URLRequestConvertible#>, success: <#T##(Decodable & Encodable) -> Void#>)
        }
    }
    
}

