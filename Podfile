# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


def mypods
  # Pod for API
  pod 'Alamofire'

  # Pod for Display Banner Message
  pod 'NotificationBannerSwift'

  # Pod for ActivityIndicator
  pod 'NVActivityIndicatorView'
end

target 'RCAPIManager' do
  project './RCAPIManager.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
#  use_frameworks!

  # Pods for RCAPIManager
  mypods
 

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
  end
 end
end
