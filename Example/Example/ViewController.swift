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
        self.postRequest()
    }
    
    func getRequest() {
        
        let requestType = RequestType(url: "https://reqres.in/api/users?page=1", method: .get)
        
        APIManager.shared.requestJSON(model: UserListDataModel.self, request: requestType) { (responseModel) in
            
            if let users = responseModel.data {
                _ = users.map({print("User email ",$0.email ?? "")})
            }
            
            print("Total Page count ",responseModel.total_pages ?? 0)
            
        }
    }
    
    func postRequest() {
        
        let params = [
            "name":"Rohan",
            "job":"IOS Developer"
        ]
        
        let requestType = RequestType(url: "https://reqres.in/api/users", method: .post, parameters: params)
        
        APIManager.shared.requestJSON(model: UserModel.self, request: requestType) { (responseModel) in
            
            print(responseModel.name)
        }
    }
    
}

