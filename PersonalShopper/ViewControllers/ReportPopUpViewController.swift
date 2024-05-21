//
//  ReportPopUpViewController.swift
//  appName
//
//  Created by iOS Dev on 22/08/22.
//

import UIKit

class ReportPopUpViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Label: UILabel!
    @IBOutlet weak var answer2Label: UILabel!
    @IBOutlet weak var answer3Label: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var answer2View: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var isappName = false
    var msgStr = ""
    var isOther = false
    var reportId = ""

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.msgStr != "" {
            self.callReportApi(id: self.reportId, message: self.msgStr)
        }else if self.isOther {
            self.showAlert(withTitle: appName, withMessage: "Please enter reason to report")
        }else {
            self.showAlert(withTitle: appName, withMessage: "Please choose a reason to report")
        }
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {

        self.clearAll()
        if sender.tag == 100 {
            self.msgStr = ""
            self.isOther = false
            self.answer1Button.isSelected = true
            self.msgStr = self.answer1Label.text ?? ""
        }else if sender.tag == 101 {
            self.msgStr = ""
            self.answer2Button.isSelected = true
            self.msgStr = self.answer2Label.text ?? ""
            self.isOther = false
        }else if sender.tag == 102 {
            self.textBgView.isHidden = false
            self.isOther = true
            self.answer3Button.isSelected = true
        }
    }

}

// MARK: - Helper methods
extension ReportPopUpViewController {
    
    func initialSetup() {
        self.textBgView.isHidden = true
        
        if self.isappName {
            self.questionLabel.text = "Why are you reporting this favs?"
            self.answer2View.isHidden = true
        }else {
            self.questionLabel.text = "Why are you reporting this account?"
            self.answer2View.isHidden = false
        }

        self.clearAll()
    }
    
    func clearAll() {
        self.answer1Button.isSelected = false
        self.answer2Button.isSelected = false
        self.answer3Button.isSelected = false
        self.msgStr = ""
        self.textBgView.isHidden = true
    }
    
    // MARK: - Webservice methods
    func callReportApi(id: String, message: String) {
        
        let url = BaseUrl + kReportApi
        
        var parameters = [String: Any]()
        
        if self.isappName {
            parameters = ["appnameId": id, "message": message]
        }else {
            parameters = ["reportedTo": id, "message": message]
        }
        
        APIService.sharedInstance.postDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SendConnectionResponseModel.self, from: data)
                        
                        if modelObj.success == true {
                            AlertController.alert(title: appName, message: modelObj.message ?? kSomethingWentWrong, buttons: ["Ok"]) { alert, index in
                                self.dismiss(animated: true)
                            }
                        }else {
                            if modelObj.message == sessionExpiredCheckMsg {
                                AlertController.alert(title: sessionExpiredTitle, message: sessionExpiredSubTitle, buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                    SharedClass.sharedInstance.gotoLogin(view: self.view)
                                }
                            }else {
                                self.showAlert(withTitle: appName, withMessage: modelObj.message ?? kSomethingWentWrong)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    
}

// MARK: - UITextViewDelegate methods
extension ReportPopUpViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.msgStr = textView.text.trimWhiteSpace
    }
    
}
