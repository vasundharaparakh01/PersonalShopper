//
//  ApiClient.swift
//  MVVMSample
//
//  Created by Antonio Corrales on 26/6/18.
//  Copyright © 2018 DesarrolloManzana. All rights reserved.
//

import Foundation
import MBProgressHUD

class APIService :  NSObject {
    
    static let sharedInstance = APIService()
    let session = URLSession.shared
    
    // MARK: - Get methods
    func getDataFromServer(url: String, view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
        
        print("URL:=====",url)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: URL(string: url)!) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        } else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
    
    func getDataFromServerByAccessToken(url: String, view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
        
        print("URL:=====",url)
        
        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
            request.addValue(token, forHTTPHeaderField: "authorization")
        }
//        request.addValue(Token.sharedInstance.tokenString, forHTTPHeaderField: "authorization")
//        request.addValue("Bearer " + AuthTokenString, forHTTPHeaderField: "Authorization")

        print("Request:=====",request)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
    
//    func getDataFromServerByAccessTokenWithParams(url: String, params: [String: Any], view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
//
//        print("URL:=====",url)
//        print("PARAMETERS:=====",params)
//
//        // create the url with URL
//        let url = URL(string: url)! // change server url accordingly
//
//        // now create the URLRequest object using the url object
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        // add headers for the request
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
//        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
//            request.addValue(token, forHTTPHeaderField: "authorization")
//        }
////        request.addValue(Token.sharedInstance.tokenString, forHTTPHeaderField: "authorization")
////        request.addValue("Bearer " + AuthTokenString, forHTTPHeaderField: "Authorization")
//
//        do {
//          // convert parameters to Data and assign dictionary to httpBody of request
//          request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//        } catch let error {
//          print(error.localizedDescription)
//          return
//        }
//
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }
//
//        if Reachability.isConnectedToNetwork() {
//            let hud = MBProgressHUD.showAdded(to: view, animated: true)
//            hud.label.text = ""
//            hud.isUserInteractionEnabled = false
//            window.isUserInteractionEnabled = false
//
//            let task = session.dataTask(with: request) { (data, urlResponse, error) in
//                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: view, animated: true)
//                    window.isUserInteractionEnabled = true
//
//                    if error != nil {
//                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
//                    }else {
//                        if data != nil {
//                            let json = self.dataToJSON(data: data!)
//                            print(json as Any)
//                            callback(true, data, json, nil)
//                        }else {
//                            callback(false, nil, nil, "try again")
//                        }
//                    }
//                }
//            }
//            task.resume()
//        }else {
//            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
//        }
//
//    }
    
    // MARK: - Post methods
    func postDataOnServerByAccessToken(loadingText: String = "", url: String, params: [String: Any], view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
        
        print("URL:=====",url)
        print("PARAMETERS:=====",params)
        
        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
            request.addValue(token, forHTTPHeaderField: "authorization")
        }

        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.detailsLabel.text = loadingText
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
    
    func postDataOnServer(url: String, params: [String: Any], view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
        
        print("URL:=====",url)
        print("PARAMETERS:=====",params)
        
        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
       
    func postDataOnServerByAccessTokenInFormData(url: String, params: [String: Any], images:[UIImage], imageKey:String, isAuth:Bool, view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()) {
        
        print("URL:=====",url)
        print("PARAMETERS:=====",params)
                
        let boundary = generateBoundaryString()
        
        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        // add headers for the request
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if isAuth {
            if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
                request.addValue(token, forHTTPHeaderField: "authorization")
            }
        }

        var mediaImages = [Media]()
        for image in images {
            if let mediaImage = Media(withImage: image, forKey: imageKey) {
                mediaImages.append(mediaImage)
            }
        }

        let dataBody = createDataBody(withParameters: params, media: mediaImages, boundary: boundary)
        request.httpBody = dataBody
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        
        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
    
    // MARK: - Put methods
    func putDataOnServerByAccessToken(url: String, params: [String: Any], view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
        
        print("URL:=====",url)
        print("PARAMETERS:=====",params)
        
        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //set http method as POST
        
        // add headers for the request
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
            request.addValue(token, forHTTPHeaderField: "authorization")
        }
//        request.addValue(Token.sharedInstance.tokenString, forHTTPHeaderField: "authorization")

        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
    
    func putDataOnServerByAccessTokenInFormData(url: String, params: [String: String], image:UIImage, imageKey:String, view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()) {
        
        print("URL:=====",url)
        print("PARAMETERS:=====",params)
                
        let boundary = generateBoundaryString()
        guard let mediaImage = Media(withImage: image, forKey: imageKey) else { return }

        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //set http method as POST

        // add headers for the request
        // add headers for the request
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
            request.addValue(token, forHTTPHeaderField: "authorization")
        }

        let dataBody = createDataBody(withParameters: params, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody

        //        let fileURL = Bundle.main.url(forResource: "image", withExtension: "png")!
        
//        do {
//          // convert parameters to Data and assign dictionary to httpBody of request
//          request.httpBody = try createBody(with: params, filePathKey: "file", urls: [fileURL], boundary: boundary)
//        } catch let error {
//          print(error.localizedDescription)
//          return
//        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        
        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }

    func putDataOnServerByAccessTokenInFormDataWithMultipleImages(url: String, params: [String: Any], images:[UIImage], imageKey:String, view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()) {
        
        print("URL:=====",url)
        print("PARAMETERS:=====",params)
                
        let boundary = generateBoundaryString()

        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //set http method as POST

        // add headers for the request
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
            request.addValue(token, forHTTPHeaderField: "authorization")
        }
        
        var mediaImages = [Media]()
        for image in images {
            guard let mediaImage = Media(withImage: image, forKey: imageKey) else { return }
            mediaImages.append(mediaImage)
        }

        let dataBody = createDataBody(withParameters: params, media: mediaImages, boundary: boundary)
        request.httpBody = dataBody
                
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        
        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }

    
    // MARK: - Delete methods
    func deleteDataOnServerByAccessToken(url: String, view: UIView, callback: @escaping (_ success : Bool, _ response : Data?, _ responseJson: Any?, _ errorMsg: String?) -> ()){
        
        print("URL:=====",url)
        
        // create the url with URL
        let url = URL(string: url)! // change server url accordingly
                
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        if let token = UserDefaults.standard.value(forKey: UserDefaults.Keys.Token.rawValue) as? String {
            request.addValue(token, forHTTPHeaderField: "authorization")
        }

        print("Request:=====",request)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

        if Reachability.isConnectedToNetwork() {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = ""
            hud.isUserInteractionEnabled = false
            window.isUserInteractionEnabled = false

            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: view, animated: true)
                    window.isUserInteractionEnabled = true

                    if error != nil {
                        callback(false, nil, nil, error?.localizedDescription ?? "try again")
                    }else {
                        if data != nil {
                            let json = self.dataToJSON(data: data!)
                            print(json as Any)
                            callback(true, data, json, nil)
                        }else {
                            callback(false, nil, nil, "try again")
                        }
                    }
                }
            }
            task.resume()
        }else {
            SharedClass.sharedInstance.alertWindow(title:"No Internet Connection", message:"Make sure your device is connected to the internet.")
        }
        
    }
    
    // MARK: - Helper methods
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }

    private func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {

        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)")
                body.append(lineBreak)
            }
        }

        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }

        body.append("--\(boundary)--\(lineBreak)")

        return body
    }


    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service.
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter urls:         The optional array of file URLs of the files to be uploaded.
    /// - parameter boundary:     The `multipart/form-data` boundary.
    ///
    /// - returns:                The `Data` of the body of the request.

    private func createBody(with parameters: [String: Any]? = nil, filePathKey: String, urls: [URL], boundary: String) throws -> Data {
        var body = Data()
        
        parameters?.forEach { (key, value) in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        for url in urls {
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(url.mimeType)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    
    func dataToJSON(data: Data) -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! Dictionary<String, AnyObject>
            return json
        } catch {
            print("Something went wrong")
        }
       return nil
    }

}

struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String

    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpg"
        self.fileName = "\(arc4random()).jpeg"

        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
        self.data = data
    }
}
