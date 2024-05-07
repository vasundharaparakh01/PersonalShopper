//
//  FacebookLogin.swift
//
//  Created by Vasundhara Parakh on 26/12/19.
//  Copyright © 2019 Vasundhara Parakh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookLoginViewModel: NSObject {

    typealias typeCompletionHandler = ([String:Any]?, Error?) -> ()
    lazy var okCompletion : typeCompletionHandler = {_ , _ in}
    
    required override init() {
        super.init()
    }
    
    //TODO:- Login using custom button
    func loginWithFacebook(_ loginCompletionHandler: @escaping typeCompletionHandler){
        self.okCompletion = loginCompletionHandler
        if let controller = UIApplication.topViewController() {
            self.openFBController(target: controller)
        }
    }
    
    func openFBController(target: UIViewController){
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: target) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil), let dictResponse = result as? Dictionary<String,Any>{
                    //everything works print the user data
                    var dictForResponse = [String:Any]()
                    dictForResponse["loginType"] = "facebook"
                    dictForResponse[Keys.email] = dictResponse[Keys.email] as? String
                    dictForResponse[Keys.firstname] = dictResponse["first_name"] as? String
                    dictForResponse[Keys.lastname] = dictResponse["last_name"] as? String
                    dictForResponse["profilePic"] = (((dictResponse["picture"] as? Dictionary<String,Any> ?? [:])["data"] as? Dictionary<String,Any> ?? [:])["url"] as? String ?? "")
             
                    self.okCompletion(dictForResponse,nil)
                } else {
                    self.okCompletion(nil,error)
                }
            })
        }
    }
}
