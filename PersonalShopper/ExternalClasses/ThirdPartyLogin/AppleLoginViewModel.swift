//
//  AppleLoginViewModel.swift
//
//  Created by Vasundhara Parakh on 26/12/19.
//  Copyright © 2019 Vasundhara Parakh. All rights reserved.
//

import UIKit
import AuthenticationServices

class AppleLoginViewModel: NSObject {
    
    typealias typeCompletionHandler = ([String:Any]?, Error?) -> ()
    lazy var okCompletion : typeCompletionHandler = {_ , _ in}
    
    required override init() {
        super.init()
    }
    
    @available(iOS 13.0, *)
    func loginWithApple(_ loginCompletionHandler: @escaping typeCompletionHandler){
        self.okCompletion = loginCompletionHandler
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

//MARK:- ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension AppleLoginViewModel : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIdCredentials = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifire = appleIdCredentials.user
          //  let fullName = appleIdCredentials.fullName
            let email = appleIdCredentials.email
            var dictForResponse = [String:Any]()
            dictForResponse["loginType"] = "apple"
            dictForResponse[Keys.email] = email ?? ""
            dictForResponse[Keys.firstname] = appleIdCredentials.fullName?.givenName ?? ""
            dictForResponse[Keys.lastname] = appleIdCredentials.fullName?.familyName ?? ""
            dictForResponse["profilePic"] = ""
            okCompletion(dictForResponse,nil)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        okCompletion(nil,error)
        print(error.localizedDescription)
    }
}
