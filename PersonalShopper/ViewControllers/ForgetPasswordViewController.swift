//
//  ForgetPasswordViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 03/08/22.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let validated = self.isValidateAllFields()
        if validated.isValidate {
            self.callSendOtpApi(email: self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        }else {
            self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
        }
        
    }

}

// MARK: - Helper methods
extension ForgetPasswordViewController {
    
    func initialSetup() {
    }
    
    func isValidateAllFields() -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
        if self.emailTextField.text?.trimWhiteSpace == "" {
            errorMsg = blankEmail
            self.emailTextField.becomeFirstResponder()
        }
        else if !(self.emailTextField.text?.trimWhiteSpace.isValidEmail)! {
            errorMsg = invalidEmail
            self.emailTextField.becomeFirstResponder()
        }
        else {
            isValidate = true
        }
        return (isValidate, errorMsg)
    }
    
    // MARK: - Webservice methods
    func callSendOtpApi(email: String) {
        
        let url = BaseUrl + kAuth + kForgetPasswordApi
        guard let fcmToken = UserDefaults.standard.value(forKey: kFcmToken) as? String else {
            showAlert(withTitle: appName, withMessage: kSomethingWentWrong)
            
            return
        }
        let parameters: [String: Any] = ["email": email]

        APIService.sharedInstance.postDataOnServer(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SignupModel.self, from: data)
                                                
                        if modelObj.success == true {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController
                            nextVC?.isForgetPassword = true
                            nextVC?.email = email
                            nextVC?.otp = modelObj.message ?? ""
                            self.navigationController?.pushViewController(nextVC!, animated: true)
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
extension ForgetPasswordViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
            let validated = self.isValidateAllFields()
            if validated.isValidate {
                self.callSendOtpApi(email: self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
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
        default:
            break
        }
        return true
    }

}
