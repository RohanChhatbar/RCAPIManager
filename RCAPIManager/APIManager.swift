//
//  AFAPIManager.swift
//  Test
//
//  Created by Rohan on 07/06/21.
//

import Foundation
import Alamofire
import NotificationBannerSwift
import UIKit

class Connectivity
{
    class func isConnectedToInternet() ->Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}


public struct AppString {
    
    public struct Messages {
        public static let checkInternetConnection = "Please Check Your Internet Connection."
        public static let logoutMsg = "Are you sure you want to logout?"
        public static let usersession = "Your session is expired please login again."
        public static let nodata = "No Data Found."
    }
}

public var baseURL = ""

public struct AppColor {
    public static var appblueColor = UIColor.blue
}

public func RCPrint(_ string:String,_ data:Any? = nil) {
    #if DEBUG
    if let data = data {
        print(string, data)
    } else {
        print(string)
    }
    #endif
}

public class APIManager {
    // MARK: - Properties
    var sessionManager = Alamofire.Session()
    
    public static let shared = APIManager()
    
    var prevBanner : FloatingNotificationBanner?
    
    func noInternetConnectonMessage() {
        self.showMesaageBar(message: AppString.Messages.checkInternetConnection, bstyle: .danger)
    }
    
    fileprivate func handleReposneWith<T: Codable>(_ response: AFDataResponse<Data>,model: T.Type,progressShow:Bool = true,isFailureMessageDisplay : Bool = true,failure: @escaping (String) -> () = {_ in },
                                                   success: @escaping (_ value: T) -> Void) {
        let statusCode = response.response?.statusCode ?? -1
        
        RCPrint("-----------------------------\nSTATUSCODE:\n-----------------------------\n",statusCode)
        
        switch response.result {
        case .success(let data):
            
            if let json = dataToJSON(data: data) {
                RCPrint("\n-----------------------------\nRESPONSE:\n-----------------------------\n", json)
            }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                success(model)
            } catch let error {
                RCPrint("JSON Decoder array")
                failure(error.localizedDescription)
            }
            
        case .failure(let error):
            if statusCode == 401 {
                self.directSignout(completion: {
                    RCPrint("Signout")
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.showMesaageBar(message: AppString.Messages.usersession, bstyle: .danger)
                }
            } else {
                let message = error.localizedDescription
                self.showMesaageBar(message: message, bstyle: .danger)
            }
            
            failure(error.localizedDescription)
        }
        if progressShow {
            showRandomProgress(isShow: false)
        }
    }
    
    public func requestJSON<T: Codable>(model: T.Type,progressShow:Bool = true,request: RequestType,isFailureMessageDisplay : Bool = true,failure: @escaping (String) -> () = {_ in },
                                        success: @escaping (_ value: T) -> Void) {
        if Connectivity.isConnectedToInternet(){
            
            if progressShow {
                showRandomProgress(isShow: true)
            }
            URLCache.shared.removeAllCachedResponses()
            
            if let convertible = asURLReqeust(request: request) {
                
                RCPrint("\n-----------------------------\nREQUEST:\n-----------------------------\n", request.url)
                
                RCPrint("\n-----------------------------\nMETHOD:\n-----------------------------\n", request.method.rawValue)
                
                if let header = request.headers {
                    RCPrint("\n-----------------------------\nHEADERS:\n-----------------------------\n", header)
                }
                
                if let params = request.parameters {
                    RCPrint("\n-----------------------------\nPARAMETER:\n-----------------------------\n",params)
                }
                
                sessionManager.request(convertible)
                    .responseData { (dataResponse) in
                        self.handleReposneWith(dataResponse, model: model, progressShow: progressShow, isFailureMessageDisplay: isFailureMessageDisplay, failure: failure, success: success)
                    }
            }
            
            
        } else {
            noInternetConnectonMessage()
        }
        
    }
    
    
    public func uploadWithImage<T: Codable>(model: T.Type,progressShow:Bool = true,request: RequestType,keyName:[String],imageName:[String], images: [UIImage?],isFailureMessageDisplay : Bool = true,failure: @escaping (String) -> () = {_ in }, success: @escaping (_ value: T) -> Void) {
        
        if Connectivity.isConnectedToInternet(){
            if progressShow {
                showRandomProgress(isShow: true)
            }
            
            RCPrint("\n-----------------------------\nREQUEST:\n-----------------------------\n", request.url)
            
            RCPrint("\n-----------------------------\nMETHOD:\n-----------------------------\n", request.method.rawValue)
            
            if let header = request.headers {
                RCPrint("\n-----------------------------\nHEADERS:\n-----------------------------\n", header)
            }
            
            if let params = request.parameters {
                RCPrint("\n-----------------------------\nPARAMETER:\n-----------------------------\n",params)
            }
            let httpHeaders = HTTPHeaders(request.headers ?? [String:String]())
            _ = AF.upload(multipartFormData: { multiPart in
                if let params = request.parameters {
                    for p in params {
                        multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                    }
                }
                
                let images = images
                for (index,image) in images.enumerated() {
                    if let newImage = image, let imageData = newImage.jpegData(compressionQuality: 0.1) {
                        var image_name = ""
                        if imageName[index].contains(".jpg") || imageName[index].contains(".png") {
                            image_name = imageName[index]
                        } else {
                            image_name = "\(imageName[index]).jpg"
                        }
                        multiPart.append(imageData, withName: keyName[index], fileName: image_name, mimeType: "image/jpg")
                    }
                }
                
                
            }, to: request.url, method: request.method, headers: httpHeaders) .uploadProgress(queue: .main, closure: { progress in
                RCPrint("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseData { (dataResponse) in
                self.handleReposneWith(dataResponse, model: model, progressShow: progressShow, isFailureMessageDisplay: isFailureMessageDisplay, failure: failure, success: success)
            }
        } else {
            noInternetConnectonMessage()
        }
        
    }
    
    public func uploadWithURL<T: Codable>(model: T.Type,progressShow:Bool = true,request: RequestType,keyName:[String],fileName:[String], fileurls: [URL?],isFailureMessageDisplay : Bool = true,failure: @escaping (String) -> () = {_ in }, success: @escaping (_ value: T) -> Void) {
        
        if Connectivity.isConnectedToInternet(){
            if progressShow {
                showRandomProgress(isShow: true)
            }
            
            RCPrint("\n-----------------------------\nREQUEST:\n-----------------------------\n", request.url)
            
            RCPrint("\n-----------------------------\nMETHOD:\n-----------------------------\n", request.method.rawValue)
            
            if let header = request.headers {
                RCPrint("\n-----------------------------\nHEADERS:\n-----------------------------\n", header)
            }
            
            if let params = request.parameters {
                RCPrint("\n-----------------------------\nPARAMETER:\n-----------------------------\n",params)
            }
            
            let httpHeaders = HTTPHeaders(request.headers ?? [String:String]())
            _ = AF.upload(multipartFormData: { multiPart in
                
                if let params = request.parameters {
                    for p in params {
                        multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                    }
                }
                
                
                let fileurls = fileurls
                for (index,url) in fileurls.enumerated() {
                    if let newURL = url {
                        do{
                            let docData = try Data(contentsOf: newURL)
                            multiPart.append(docData, withName: keyName[index], fileName: fileName[index], mimeType: newURL.mimeType())
                        }catch let err{
                            RCPrint("Error on covert file: \(err.localizedDescription)")
                            self.showMesaageBar(message: err.localizedDescription, bstyle: .danger)
                        }
                    }
                    
                }
                
            }, to: request.url, method: request.method, headers: httpHeaders) .uploadProgress(queue: .main, closure: { progress in
                RCPrint("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseData { (dataResponse) in
                self.handleReposneWith(dataResponse, model: model, progressShow: progressShow, isFailureMessageDisplay: isFailureMessageDisplay, failure: failure, success: success)
            }
        } else {
            noInternetConnectonMessage()
        }
        
    }
    
    public func directSignout(completion:()->()) {
        completion()
        //        UIApplication.shared.applicationIconBadgeNumber = 0
        //        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        //        self.setLoginasRoot()
    }
    
    public func showMesaageBar(title: String? = nil, message : String? = nil, bstyle : BannerStyle){
        if prevBanner != nil{
            prevBanner?.dismiss()
        }
        let banner = FloatingNotificationBanner(title: title ?? "", subtitle: message ?? "", style: bstyle)
        banner.duration = 3.0
        //        banner.subtitleLabel?.font = AppFont.setFont(name: .LatoRegular, size: 14)//UIFont.systemFont(ofSize: 14)//
        banner.subtitleLabel?.numberOfLines = 0
        banner.subtitleLabel?.lineBreakMode = .byWordWrapping
        banner.show()
        prevBanner = banner
    }
}


public func showRandomProgress(isShow:Bool) {
    if isShow {
        ActivityIndicatorManager.shared.startAnimating()
    } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            ActivityIndicatorManager.shared.stopAnimating()
        })
    }
}

public func dataToJSON(data: Data) -> Any? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as Any
    } catch let myJSONError {
        RCPrint(myJSONError.localizedDescription)
    }
    return nil
}

