//
//  LoginViewController.swift
//  appName
//
//  Created by Chandani Barsagade on 5/30/22.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInbtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var facebookbtn: UIButton!
    @IBOutlet weak var googlebtn: UIButton!
    @IBOutlet weak var applebtn: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var emailId = ""
    var name = ""
    var profilePic = UIImage()
    
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func signIn(_ sender: Any) {
        self.view.endEditing(true)
        
        let validated = self.isValidateAllFields()
        if validated.isValidate {
            self.callLoginApi(username: self.usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", password: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        }else {
            self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
        }
        
    }
    
    @IBAction func forgetPasswordButtonAction(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as? ForgetPasswordViewController
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }

    @IBAction func signUpButtonAction(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController
        self.navigationController?.pushViewController(nextVC!, animated: true)
    }
    
    @IBAction func facebookLoginButtonAction(_ sender: Any) {
        self.loginWithFacebook {_ in
            self.callSocialRegistrationApi(username: self.name, email: self.emailId, password: "", confirmPassword: "", mobileNumber: "", profilePic: [self.profilePic], provider: "facebook", uniqueId: "")
        }
    }
    
    @IBAction func googleLoginButtonAction(_ sender: Any) {
        self.loginWithGoogle {_ in
            self.callSocialRegistrationApi(username: self.name, email: self.emailId, password: "", confirmPassword: "", mobileNumber: "", profilePic: [self.profilePic], provider: "google", uniqueId: "")
        }
    }
    
    @IBAction func appleLoginButtonAction(_ sender: Any) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()

    }
        
}

// MARK: - Helper methods
extension LoginViewController {
    
    func initialSetup() {
//        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.Token.rawValue)
//        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.UserInfo.rawValue)
//        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.IsLogin.rawValue)
//        UserDefaults.standard.synchronize()
        
        // Reset User Defaults
        UserDefaults.standard.reset()
        UserDefaults.standard.synchronize()

    }
    
    func isValidateAllFields() -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
        if self.usernameTextField.text?.trimWhiteSpace == "" {
            errorMsg = blankEmail
            self.usernameTextField.becomeFirstResponder()
        }
        else if !(self.usernameTextField.text?.trimWhiteSpace.isValidEmail)! {
            errorMsg = invalidEmail
            self.usernameTextField.becomeFirstResponder()
        }
        else if self.passwordTextField.text?.trimWhiteSpace == "" {
            errorMsg = blankPassword
            self.passwordTextField.becomeFirstResponder()
        }
        else if !(self.passwordTextField.text?.trimWhiteSpace.isValidPassword)! {
            errorMsg = invalidPassword
            self.passwordTextField.becomeFirstResponder()
        }
        else {
            isValidate = true
        }
        return (isValidate, errorMsg)
    }
    
    //Facebook
    func loginWithFacebook(completion: @escaping (Dictionary<String, Any>) -> Void) {
        FacebookLoginViewModel().loginWithFacebook { (userDataDict,error) in
            if userDataDict != nil{
                
                print(userDataDict)
                
                guard let email = userDataDict?[Keys.email] as? String else {
                    return
                }
                guard let username = userDataDict?[Keys.firstname] as? String else {
                    return
                }
                var profileImage = UIImage()
                if let profilePic = userDataDict?["profilePic"] as? String {
                    let imageView = UIImageView()
                    
                    imageView.sd_setImage(with: URL.init(string: profilePic), placeholderImage: UIImage(named: "userPlaceholder"), completed: { (image, error, cacheType, imageURL) in
                        profileImage = image!
                    })
                }

                self.emailId = email
                self.name = username
                self.profilePic = profileImage

                // closure call
                completion(["":""])

                //                   self.socialLoginData = userDataDict
                //                   UserDefaults.setSocialProfilePicture(pictureUrl: userDataDict?[Keys.profilePic] as! String)
                //                   self.socialApi(userDataDict, params: nil)
            }
        }
    }
    
    //Google
    func loginWithGoogle(completion: @escaping (Dictionary<String, Any>) -> Void) {
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }

            let emailAddress = user.profile?.email
            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
            

            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            print(emailAddress)
            print(fullName)
            print(givenName)
            print(familyName)
            print(profilePicUrl)
            
            guard let email = user.profile?.email as? String else {
                return
            }
            guard let username = user.profile?.name as? String else {
                return
            }

            let imageView = UIImageView()
            var profileImage = UIImage()
            
            imageView.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(named: "userPlaceholder"), completed: { (image, error, cacheType, imageURL) in
                profileImage = image!
            })
            
            self.emailId = email
            self.name = username
            self.profilePic = profileImage

            // closure call
            completion(["":""])

        }

//        GoogleLoginViewModel().loginWithGmail{(userDataDict,error) in
//            if userDataDict != nil{
//                //                   UserDefaults.setSocialProfilePicture(pictureUrl: userDataDict?[Keys.profilePic] as! String)
//                //                   self.socialLoginData = userDataDict
//                //                   self.socialApi(userDataDict, params: nil)
//            }
//        }
    }
    
    //Apple
    @available(iOS 13.0, *)
    func loginWithApple(completion: @escaping (Dictionary<String, Any>) -> Void) {
        AppleLoginViewModel().loginWithApple { (user, error) in
            if error == nil, let userDataDict = user {
                print(userDataDict)
                
                guard let email = userDataDict[Keys.email] as? String else {
                    return
                }
                guard let username = userDataDict[Keys.firstname] as? String else {
                    return
                }
                var profileImage = UIImage()
                if let profilePic = userDataDict["profilePic"] as? String {
                    let imageView = UIImageView()
                    
                    imageView.sd_setImage(with: URL.init(string: profilePic), placeholderImage: UIImage(named: "userPlaceholder"), completed: { (image, error, cacheType, imageURL) in
                        profileImage = image!
                    })
                }

                self.emailId = email
                self.name = username
                self.profilePic = profileImage

                // closure call
                completion(["":""])

            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    func socialLoginUserExist(isExist: Bool) {
        if isExist {
        }else {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController
            self.navigationController?.pushViewController(nextVC!, animated: true)
        }
    }
    
    @available(iOS 13.0, *)
    func setupAppleLoginButton(){
        //           let authorizationButton = ASAuthorizationAppleIDButton()
        //           authorizationButton.addTarget(self, action: #selector(loginWithApple(_:)), for: .touchUpInside)
        //           //        authorizationButton.cornerRadius = 10
        //           //Add button on some view or stack
        //           authorizationButton.frame = CGRect(x: 0, y: 0, width: applebtn.frame.width, height: applebtn.frame.height)
        //           self.applebtn.addSubview(authorizationButton)
    }
    
    // MARK: - Webservice methods
    func callLoginApi(username: String, password: String) {
        
        let url = BaseUrl + kAuth + kLoginApi
        guard let fcmToken = UserDefaults.standard.value(forKey: kFcmToken) as? String else {
            showAlert(withTitle: appName, withMessage: kSomethingWentWrong)
            
            return
        }
        let parameters: [String: Any] = ["email": username, "password": password, "fcmToken": fcmToken, "deviceType": "ios"]
//        let parameters: [String: Any] = ["email": "qwerty1@gmail.com", "password": "Qwerty@123"]

        APIService.sharedInstance.postDataOnServer(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(LoginModel.self, from: data)
                                                
                        // Archive
                        //                        do{
                        //                            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: modelObj.data?.userInfo as Any)
                        //                            UserDefaults.standard.set(encodedData, forKey: "UserInfo")
                        //                            UserDefaults.standard.synchronize()
                        //
                        //                        }catch (let error){
                        //                            #if DEBUG
                        //                                print("Failed to convert UIColor to Data : \(error.localizedDescription)")
                        //                            #endif
                        //                        }
                        
                        // Unarchive
                        //                        do{
                        //                            if let colorAsData = UserDefaults.standard.object(forKey: "myColor") as? Data{
                        //                                if let color = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [UIColor.self], from: colorAsData){
                        //                                    // Use Color
                        //                                }
                        //                            }
                        //                        }catch (let error){
                        //                            #if DEBUG
                        //                                print("Failed to convert UIColor to Data : \(error.localizedDescription)")
                        //                            #endif
                        //                        }
                        
                        if modelObj.success == true {
                            UserDefaults.standard.set(modelObj.data?.accessToken ?? "", forKey: UserDefaults.Keys.Token.rawValue)
                            UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsLogin.rawValue)
                            UserDefaults.standard.set(modelObj.data?.userInfo?.findByMobile, forKey: UserDefaults.Keys.FindMe.rawValue)
//                            Token.sharedInstance.tokenString = modelObj.data?.accessToken ?? ""
                            do {
                                // Encode Note
                                let userInfoData = try JSONEncoder().encode(modelObj.data?.userInfo)
                                
                                // Write/Set Data
                                UserDefaults.standard.set(userInfoData, forKey: UserDefaults.Keys.UserInfo.rawValue)
                                UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsContacts.rawValue)
                                UserDefaults.standard.synchronize()
                            } catch {
                                print("Unable to Encode Note (\(error))")
                            }
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let homeVC =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                            
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                let delegate = windowScene.delegate as? SceneDelegate else { return }

                            delegate.navController = UINavigationController(rootViewController: homeVC)
                            delegate.navController.isNavigationBarHidden = true
                            delegate.window?.rootViewController = delegate.navController
                            delegate.window?.makeKeyAndVisible()
                        }else if modelObj.message == "Please verify the email." {
                            AlertController.alert(title: appName, message: modelObj.message ?? kSomethingWentWrong, buttons: ["Ok", "Cancel"]) { UIAlertAction, selectedIndex in
                                
                                if selectedIndex == 0 {
                                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController
                                    nextVC?.token = modelObj.error?.token ?? ""
                                    nextVC?.otp = modelObj.error?.otp ?? ""
                                    self.navigationController?.pushViewController(nextVC!, animated: true)
                                }
                            }
                        }else {
                            self.showAlert(withTitle: appName, withMessage: modelObj.message ?? kSomethingWentWrong)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    
    func callSocialRegistrationApi(username: String, email: String, password: String, confirmPassword: String, mobileNumber: String, profilePic: [UIImage], provider: String, uniqueId: String) {
        
        guard let fcmToken = UserDefaults.standard.value(forKey: kFcmToken) as? String else {
            showAlert(withTitle: appName, withMessage: kSomethingWentWrong)
            
            return
        }

        let url = BaseUrl + kAuth + kSocialLoginApi
        
        var parameters = Dictionary<String, Any>()
        
        if provider == "apple" {
//            parameters = ["username": username, "email": email, "fcmToken": fcmToken, "deviceType": "ios", "provider": provider, "uniqueId": uniqueId, "mobilenumber":"+919999999999"]
            parameters = ["username": username, "email": email, "fcmToken": fcmToken, "deviceType": "ios", "provider": provider, "uniqueId": uniqueId]
        }else {
//            parameters = ["username": username, "email": email, "fcmToken": fcmToken, "deviceType": "ios", "provider": provider, "mobilenumber":"+919999999999"]
            parameters = ["username": username, "email": email, "fcmToken": fcmToken, "deviceType": "ios", "provider": provider]
        }

        APIService.sharedInstance.postDataOnServer(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SocialSignupModel.self, from: data)
                        if modelObj.success == true {
                            if let accessToken = modelObj.data?.accessToken as? String, accessToken != "" {
                                UserDefaults.standard.set(modelObj.data?.accessToken ?? "", forKey: UserDefaults.Keys.Token.rawValue)
                                UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsLogin.rawValue)
                                UserDefaults.standard.set(modelObj.data?.userInfo?.findByMobile, forKey: UserDefaults.Keys.FindMe.rawValue)
    //                            Token.sharedInstance.tokenString = modelObj.data?.accessToken ?? ""
                                do {
                                    // Encode Note
                                    let userInfoData = try JSONEncoder().encode(modelObj.data?.userInfo)
                                    
                                    // Write/Set Data
                                    UserDefaults.standard.set(userInfoData, forKey: UserDefaults.Keys.UserInfo.rawValue)
                                    UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsContacts.rawValue)
                                    UserDefaults.standard.synchronize()
                                } catch {
                                    print("Unable to Encode Note (\(error))")
                                }
                            }
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let homeVC =  storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                let delegate = windowScene.delegate as? SceneDelegate else { return }

                            delegate.navController = UINavigationController(rootViewController: homeVC)
                            delegate.navController.isNavigationBarHidden = true
                            delegate.window?.rootViewController = delegate.navController
                            delegate.window?.makeKeyAndVisible()

                        }else {
                            self.showAlert(withTitle: appName, withMessage: modelObj.message ?? kSomethingWentWrong)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }

}

//MARK: - UITextFieldDelegates Methods
extension LoginViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
            let validated = self.isValidateAllFields()
            if validated.isValidate {
                self.callLoginApi(username: self.usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", password: self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            }else {
                self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
            }

        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        switch textField.tag {
        case 100:
            if str.length > emailMaxLength {
                return false
            }
        case 101:
            if str.length > passwordMaxLength {
                return false
            }
            break
        default:
            break
        }
        return true
    }

}

// MARK: - ASAuthorizationControllerDelegate methods
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            self.callSocialRegistrationApi(username: fullName?.givenName ?? "", email: email ?? "", password: "", confirmPassword: "", mobileNumber: "", profilePic: [self.profilePic], provider: "apple", uniqueId: userIdentifier)

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                 switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                     print("The Apple ID credential is valid.")
                        break
                    case .revoked:
                        // The Apple ID credential is revoked.
                     print("The Apple ID credential is revoked.")
                        break
                 case .notFound:
                        // No credential was found, so show the sign-in UI.
                     print("No credential was found, so show the sign-in UI.")
                    default:
                        break
                 }
            }

        }
            
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        print("Handle error=====",error)
    }
}
