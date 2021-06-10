# RCAPIManager

RCAPIManager is a wrapper around Alamofire in Swift to simplify HTTP requests.

## Features
`Network Reachability`
`Generic Api Request`
`Return Codable Model`
`Upload file MultipartFormData`



## Installation
### CocoaPods

Check out [RCAPIManager](https://cocoapods.org/pods/RCAPIManager) on cocoapods.org.

To use RCAPIMANAGER in your project add the following 'Podfile' to your project

```bash
source 'https://github.com/RohanChhatbar/RCAPIManager.git'
platform :ios, '10.0'
use_frameworks!

pod 'RCAPIMANAGER', '~> 0.0.2'
```

## Usage
Check example directory in project
### GET Request

```
if let request = try? URLRequest(url: "https://reqres.in/api/users?page=1", method: .get) {

  APIManager.shared.requestJSON(model: UserListDataModel.self, convertible: request) { (responseModel) in

//Here Return UserListDataModel
                
       if let users = responseModel.data {
           _ = users.map({print("User email ",$0.email ?? "")})
       }
                
       print("Total Page count ",responseModel.total_pages ?? 0)
   }
}
```

### POST Request

```
let params = [
    "name":"Rohan",
    "job":"IOS Developer"
]

let requestType = RequestType(url: "https://reqres.in/api/users", method: .post, parameters: params)
        
if let request = asURLReqeust(type: requestType) {
            
      APIManager.shared.requestJSON(model: UserModel.self, convertible: request) { (responseModel) in
           print(responseModel.name)
      }
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
