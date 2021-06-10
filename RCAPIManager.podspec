#
#  Be sure to run `pod spec lint RCAPIManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "RCAPIManager"
  spec.version      = "0.0.2"
  spec.summary      = "APIManager for IOS."
  spec.description  = "APIManger Class for IOS With Alamofire"
  spec.homepage     = "https://github.com/RohanChhatbar/RCAPIManager"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Rohan Chhatbar" => "rohanchhatbar1993@gmail.com" }
  spec.social_media_url   = "https://www.linkedin.com/in/rohan-chhatbar-913a4912a/"
  spec.swift_version = '4.2'
  spec.platform     = :ios
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/RohanChhatbar/RCAPIManager.git", :tag => "#{spec.version}" }
  spec.source_files  = 'RCAPIManager/*.{swift, h}'
  spec.dependency 'Alamofire'
  spec.dependency 'NVActivityIndicatorView'
  spec.dependency 'NotificationBannerSwift'

end
