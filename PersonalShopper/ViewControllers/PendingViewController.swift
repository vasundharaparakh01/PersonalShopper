//
//  PendingViewController.swift
//  appName
//
//  Created by iOS Dev on 01/07/22.
//

import UIKit
import SideMenu
import SDWebImage

class PendingViewController: UIViewController {

    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!

    var pendingRequest = [PendingRequestModelData]()
    var pendingResponse = [PendingResponseModelData]()
    var selectedIndex = 0
    var noDataMessage = ""    

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.transform = self.bgImageView.transform.rotated(by: CGFloat(Double.pi))
        self.initialSetup()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
//        UserDefaults.standard.set(ScreenType.pendingRequest, forKey: UserDefaults.Keys.ScreenName.rawValue)
//    }

    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func categorySegmentAction(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        self.callApiMethod()
    }
    
    @objc func acceptButtonAction(sender: UIButton) {
        if sender.titleLabel?.text == "Cancel" {
            if self.pendingResponse.count > 0 {
                let request = self.pendingResponse[0].recipients?[sender.tag]
                self.callSendConnectionResponseApi(connectionId: request?.recipientId ?? "", status: "CANCELLED")
            }
        }else {
            if self.pendingRequest.count > 0 {
                let request = self.pendingRequest[0].requesters?[sender.tag]
                self.callSendConnectionResponseApi(connectionId: request?.requesterId ?? "", status: "ACCEPTED")
            }
        }
    }

    @objc func crossButtonAction(sender: UIButton) {
        if self.pendingRequest.count > 0 {
            let request = self.pendingRequest[0].requesters?[sender.tag]
            self.callSendConnectionResponseApi(connectionId: request?.requesterId ?? "", status: "REJECTED")
        }
    }

    @objc func cancelButtonAction(sender: UIButton) {
    }

}


//MARK: Helper methods
extension PendingViewController {
    
    func initialSetup() {
        self.setSegmentControl()
        self.callApiMethod()

    }
    
    func callApiMethod() {
        if self.selectedIndex == 0 {
            self.callFetchPendingRequestApi()
        }else {
            if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
                do {
                    // Encode Note
                    let userInfoData = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                    self.callFetchPendingResponseApi(connectionId: userInfoData.id ?? "", status: "ACCEPTED")
                } catch {
                    print("Unable to Encode Note (\(error))")
                }
            }
        }

    }
    
    func setSegmentControl(){
                
        self.categorySegmentControl.selectedSegmentIndex = selectedIndex

        let normalFont = UIFont(name:"Montserrat-Regular",size:16.0)
        let boldFont = UIFont(name:"Montserrat-Bold",size:16.0)

        let normalTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: normalFont!
        ]

        let boldTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : boldFont!,
        ]

        self.categorySegmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.categorySegmentControl.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
    
    // MARK: - Webservice methods
    func callFetchPendingRequestApi() {

        let url = BaseUrl + kFetchPendingRequestsApi
        self.noDataMessage = ""
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(PendingRequestModel.self, from: data)
                        if modelObj.success == true {
                            self.pendingRequest = modelObj.data ?? []
                            self.noDataMessage = "No data available"
                            self.tableView.reloadData()
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

    func callFetchPendingResponseApi(connectionId: String, status: String) {
        
        let url = BaseUrl + kFetchPedingResponseApi + "?connectionId=\(connectionId)&status=\(status)"
        self.noDataMessage = ""

        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(PendingResponseModel.self, from: data)
                                                
                        if modelObj.success == true {
                            self.pendingResponse = modelObj.data ?? []
                            self.noDataMessage = "No data available"
                            self.tableView.reloadData()
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
    
    func callSendConnectionResponseApi(connectionId: String, status: String) {
        
        let url = BaseUrl + ksendConnectionResponseApi
        let parameters: [String: Any] = ["connectionId": connectionId, "status": status]

        APIService.sharedInstance.postDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in

            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SendConnectionResponseModel.self, from: data)
                                                
                        if modelObj.success == true {
                            self.callApiMethod()
                        }else if modelObj.message == "Connection rejected!" {
                            self.callApiMethod()
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

//MARK: UITableViewDelegate, UITableViewDataSource methods
extension PendingViewController : UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if self.selectedIndex == 0 {
            if self.pendingRequest.count > 0 {
                numOfSections            = 1
                tableView.backgroundView = nil
                return numOfSections
            }
        }else {
            if self.pendingResponse.count > 0 {
                numOfSections            = 1
                tableView.backgroundView = nil
                return numOfSections
            }
        }
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = self.noDataMessage
        noDataLabel.font = UIFont.init(name: "Poppins-Regular", size: 15.0)
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == 0 {
            if self.pendingRequest.count > 0 {
                return self.pendingRequest[0].requesters?.count ?? 0
            }
        }else {
            if self.pendingResponse.count > 0 {
                return self.pendingResponse[0].recipients?.count ?? 0
            }

        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTableViewCell") as! PendingTableViewCell
        
        cell.statusButton.backgroundColor = .red
        cell.statusButton.tag = indexPath.row
        cell.crossButton.tag = indexPath.row
        cell.crossButton.isHidden = true

//        let sizeObj = self.sizeByCatArray[indexPath.row]
                
//        if let imageUrl = self.sizeByCatModel?.image {
//            cell.sizeImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
//        }
        if self.selectedIndex == 0 {
            if self.pendingRequest.count > 0 {
                let request = self.pendingRequest[0].requesters?[indexPath.row]
                
                cell.nameLabel.text = request?.username
                if request?.status == "PENDING" {
                    cell.crossButton.isHidden = false

                    cell.statusButton.setTitle("Accept", for: .normal)
                    cell.statusButton.backgroundColor = .systemGreen
                    cell.statusButton.addTarget(self, action: #selector(self.acceptButtonAction(sender:)), for: .touchUpInside)
                    cell.crossButton.addTarget(self, action: #selector(self.crossButtonAction(sender:)), for: .touchUpInside)
                }

                if let imageUrl = request?.profilePicture as? String {
                    cell.userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
                }
            }
        }else {
            if self.pendingResponse.count > 0 {
                let request = self.pendingResponse[0].recipients?[indexPath.row]
                
                cell.nameLabel.text = request?.username
                if request?.status == "PENDING" {
                    cell.statusButton.setTitle("Cancel", for: .normal)
                    cell.statusButton.backgroundColor = .red
                    cell.statusButton.addTarget(self, action: #selector(self.acceptButtonAction(sender:)), for: .touchUpInside)
                }

                if let imageUrl = request?.profilePicture as? String {
                    cell.userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.userImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

//MARK: PendingTableViewCell
class PendingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!

}
