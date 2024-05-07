//
//  GoogleLogin.swift
//
//  Created by Vasundhara Parakh on 26/12/19.
//  Copyright © 2019 Vasundhara Parakh. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleLoginViewModel: NSObject {
    
    typealias typeCompletionHandler = (Dictionary<String,Any>?, Error?) -> ()
    
    lazy var okCompletion : typeCompletionHandler = {_ , _ in}
    
    required override init() {
        super.init()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    //TODO:--- Add following commented code on App delegate
    // Add API key inside didLaunch of app delegate
//    GIDSignIn.sharedInstance()?.clientID = "API Key"
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//         return GIDSignIn.sharedInstance().handle(url)
//     }
    
    //Add API key into the URL Schema in reverse order
    
    
    //TODO:- Check if user already login with account
    func checkIfUserAlreadyLoggedIn(_ loginCompletionHandler: @escaping typeCompletionHandler){
    
        if let controller = UIApplication.topViewController() {
            self.okCompletion = loginCompletionHandler
            GIDSignIn.sharedInstance()?.presentingViewController = controller
            //  Automatically sign in the user.
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }
    }
    
    //TODO:- Login using custom button
    func loginWithGmail(_ loginCompletionHandler: @escaping typeCompletionHandler){
         if let controller = UIApplication.topViewController() {
        self.okCompletion = loginCompletionHandler
        GIDSignIn.sharedInstance()?.presentingViewController = controller
        GIDSignIn.sharedInstance()?.signIn()
      }
    }
    
    //TODO:- Logout function
    func logoutGmail(){
        GIDSignIn.sharedInstance().signOut()
    }
}

//MARK:-- Google Login Delegates
extension GoogleLoginViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
       
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            okCompletion(nil,error)
            return
        }
        
        // Perform any operations on signed in user here.
        var responseDict : [String:Any] = [:]
        //responseDict["userID"] = user?.userID
        responseDict["loginType"] = "google"
       // responseDict["idToken"] = user?.authentication.idToken
       // responseDict["name"] = user?.profile.name
        responseDict[Keys.firstname] = user?.profile.givenName
        responseDict[Keys.lastname] = user?.profile.familyName
        responseDict[Keys.email] = user?.profile.email
        responseDict["profilePic"] = "\(String(describing: user?.profile.imageURL(withDimension: 200)! ?? URL(string: "")))"
       
        
//        var userResponse = User()
//        userResponse.email = user?.profile.email
//        userResponse.socialLoginId = user?.userID
//        if (user?.profile.name.components(separatedBy: " ").count ?? 0) > 0 , let firstName = user?.profile.name.components(separatedBy: " ").first, let lastName = user?.profile.name.components(separatedBy: " ").last {
//            userResponse.firstName = firstName
//            userResponse.lastName = lastName
//        }
        okCompletion(responseDict,nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
