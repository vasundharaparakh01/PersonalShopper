//
//  ChangePasswordViewController.swift
//  appName
//
//  Created by iOS Dev on 07/07/22.
//

import UIKit
import SideMenu

protocol ResetPasswordDelegate {
    func gotoToLoginView()
}
class ChangePasswordViewController: UIViewController {

    var delegate: ResetPasswordDelegate?
    
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var oldPasswordView: UIView!

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!

    var emailId = ""
    var isForgetPassword = false
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.transform = self.bgImageView.transform.rotated(by: CGFloat(Double.pi))
        self.initialSetup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
        UserDefaults.standard.set(ScreenType.changePassword, forKey: UserDefaults.Keys.ScreenName.rawValue)
    }

    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
                
        if self.isForgetPassword {
            let validated = self.isValidateAllFieldsForReset()
            if validated.isValidate {
                self.callResetPasswordApi(email: self.emailId, newPassword: self.newPasswordTextField.text?.trimWhiteSpace ?? "", confirmPassword: self.confirmPasswordTextField.text?.trimWhiteSpace ?? "")
            }else {
                self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
            }
        }else {
            let validated = self.isValidateAllFields()
            if validated.isValidate {
                self.callChangePasswordApi(email: self.emailId, oldPassword: self.oldPasswordTextField.text?.trimWhiteSpace ?? "", newPassword: self.newPasswordTextField.text?.trimWhiteSpace ?? "", confirmPassword: self.confirmPasswordTextField.text?.trimWhiteSpace ?? "")
            }else {
                self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
            }
        }

        
    }

}

// MARK: - Helper methods
extension ChangePasswordViewController {
    
    func initialSetup() {
    
        if self.isForgetPassword {
            self.oldPasswordView.isHidden = true
            self.headingLabel.text = "Forgot Password"
//            self.headingLabel.isHidden = false
        }else {
            self.headingLabel.text = "Change Password"
//            self.headingLabel.isHidden = true
            self.oldPasswordView.isHidden = false
            if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
                do {
                    // Decode Data
                    let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                    self.emailId = userInfoModel.email ?? ""
                } catch {
                    print("Unable to Encode Note (\(error))")
                }
                
            }
        }

    }
    
    func isValidateAllFields() -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
        if self.oldPasswordTextField.text?.trimWhiteSpace == "" {
            errorMsg = blankOldPassword
            self.oldPasswordTextField.becomeFirstResponder()
        }
        else if self.newPasswordTextField.text?.trimWhiteSpace == "" {
            errorMsg = blankNewPassword
            self.newPasswordTextField.becomeFirstResponder()
        }
        else if !(self.newPasswordTextField.text?.trimWhiteSpace.isValidPassword)! {
            errorMsg = invalidPassword
            self.newPasswordTextField.becomeFirstResponder()
        }
        else if self.newPasswordTextField.text?.trimWhiteSpace != self.confirmPasswordTextField.text?.trimWhiteSpace {
            errorMsg = mismatchPassowrdAndConfirmPassword
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        else {
            isValidate = true
        }
        return (isValidate, errorMsg)
    }
    
    func isValidateAllFieldsForReset() -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
        if self.newPasswordTextField.text?.trimWhiteSpace == "" {
            errorMsg = blankNewPassword
            self.newPasswordTextField.becomeFirstResponder()
        }
        else if !(self.newPasswordTextField.text?.trimWhiteSpace.isValidPassword)! {
            errorMsg = invalidPassword
            self.newPasswordTextField.becomeFirstResponder()
        }
        else if self.newPasswordTextField.text?.trimWhiteSpace != self.confirmPasswordTextField.text?.trimWhiteSpace {
            errorMsg = mismatchPassowrdAndConfirmPassword
            self.confirmPasswordTextField.becomeFirstResponder()
        }
        else {
            isValidate = true
        }
        return (isValidate, errorMsg)
    }

    
    // MARK: - Webservice methods
    func callChangePasswordApi(email: String, oldPassword: String, newPassword: String, confirmPassword: String) {
        
        let url = BaseUrl + kAuth + kChangePasswordApi
        let parameters: [String: Any] = ["email": email, "oldPassword": oldPassword, "newPassword": newPassword, "confirmPassword": confirmPassword]

        APIService.sharedInstance.postDataOnServer(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(LoginModel.self, from: data)
                        if modelObj.success == true {
                            AlertController.alert(title: appName, message: modelObj.message ?? kSomethingWentWrong, buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                self.dismiss(animated: true)
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

    func callResetPasswordApi(email: String, newPassword: String, confirmPassword: String) {
        
        let url = BaseUrl + kAuth + kResetPasswordApi
        let parameters: [String: Any] = ["email": email, "newPassword": newPassword, "confirmPassword": confirmPassword]

        APIService.sharedInstance.postDataOnServer(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(LoginModel.self, from: data)
                        if modelObj.success == true {
                            AlertController.alert(title: appName, message: modelObj.message ?? kSomethingWentWrong, buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                self.dismiss(animated: true) {
                                    if (self.delegate != nil) {
                                        self.delegate?.gotoToLoginView()
                                    }
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

}



//MARK: - UITextFieldDelegates Methods
extension ChangePasswordViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
            
            if self.isForgetPassword {
                let validated = self.isValidateAllFieldsForReset()
                if validated.isValidate {
                    self.callResetPasswordApi(email: self.emailId, newPassword: self.newPasswordTextField.text?.trimWhiteSpace ?? "", confirmPassword: self.confirmPasswordTextField.text?.trimWhiteSpace ?? "")
                }else {
                    self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
                }
            }else {
                let validated = self.isValidateAllFields()
                if validated.isValidate {
                    self.callChangePasswordApi(email: self.emailId, oldPassword: self.oldPasswordTextField.text?.trimWhiteSpace ?? "", newPassword: self.newPasswordTextField.text?.trimWhiteSpace ?? "", confirmPassword: self.confirmPasswordTextField.text?.trimWhiteSpace ?? "")
                }else {
                    self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
                }
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
            if str.length > passwordMaxLength {
                return false
            }
        case 101:
            if str.length > passwordMaxLength {
                return false
            }
            break
        case 102:
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

