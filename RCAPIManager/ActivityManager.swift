//
//  ActivityManager.swift
//  Test
//
//  Created by Rohan on 07/06/21.
//

import Foundation
import NVActivityIndicatorView

public class ActivityIndicatorManager {
    
    public static let shared = ActivityIndicatorManager()
    var actvityView : NVActivityIndicatorView?
    
    func bindView(frame:CGRect,color:UIColor,padding:CGFloat,type:NVActivityIndicatorType) {
        
        if actvityView != nil {
            return
        }
        actvityView = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        DispatchQueue.main.async {
            UIWindow.key?.addSubview(self.actvityView!)
        }
    }
    
    public func changeColor(color:UIColor) {
        actvityView?.color = color
    }
    
    public func startAnimating() {
        if actvityView != nil {
            actvityView?.startAnimating()
            UIWindow.key?.isUserInteractionEnabled = false
            UIWindow.key?.bringSubviewToFront(actvityView!)
        } else {
            bindLoader()
            self.startAnimating()
        }
    }
    
    public func stopAnimating() {
        if actvityView != nil {
            actvityView?.stopAnimating()
            UIWindow.key?.isUserInteractionEnabled = true
        }
    }
    
    func bindLoader() {
        let frame = CGRect(x: (UIScreen.main.bounds.size.width/2) - 25, y: (UIScreen.main.bounds.size.height/2) - 25, width: 50, height: 50)
        self.bindView(frame: frame, color: AppColor.appblueColor, padding: 5, type: .circleStrokeSpin)
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
