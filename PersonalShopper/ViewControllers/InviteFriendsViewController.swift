//
//  InviteFriendsViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 27/07/22.
//

import UIKit
import Contacts
import MBProgressHUD
import MessageUI

class InviteFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!

    var friendContact = [Dictionary<String, Any>]()
    var friendList = [String]()
    var tempFriends = [Dictionary<String, Any>]()
    var mobileArray = [String]()
    var username = ""
    var noDataMessage = ""

    var searchFriendsArray = [Dictionary<String, Any>]()

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.transform = self.bgImageView.transform.rotated(by: CGFloat(Double.pi))
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func inviteButtonAction(_ sender: UIButton) {
//        let friendObj = self.tempFriends[sender.tag]
//        guard let mobile = friendObj["mobile"] as? String else {
//            return
//        }
//        guard MFMessageComposeViewController.canSendText() else {
//            return
//        }
////        if let name = friendObj["name"] as? String, name != "" {
////            username = name + " "
////        }
//        let messageVC = MFMessageComposeViewController()
//
//        messageVC.body = "Your friend \(self.username)has invited you to use MyFavs App.\n\nView on Appstore - https://apps.apple.com/us/app/myfavs/id1626843808";
//
//        messageVC.recipients = [mobile]
//        messageVC.messageComposeDelegate = self;
//
//        self.present(messageVC, animated: false, completion: nil)
        
        
        let firstActivityItem = "Your friend \(self.username)has invited you to use MyFavs App.\n\nTo download iOS app - https://apps.apple.com/us/app/myfavs/id1626843808\n\nTo download android app - https://play.google.com/store/apps/details?id=com.myfavs"
    

        // Setting url
//        let secondActivityItem : NSURL = NSURL(string: productUrl)!
//
//        let image : UIImage = itemImage
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        
//        activityViewController.setValue("Your Subject", forKey: "Subject")
//        activityViewController.setValue("Your Subject", forKey: "to")

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)

        
        //        showAlert(withTitle: appName, withMessage: "Coming soon...")
    }
    
    @IBAction func syncContactButtonAction(_ sender: UIButton) {
//        self.callSyncContactApi(phonebook: self.mobileArray)
        self.fetchAllContactFromPhone()
    }
    
}

//MARK: Helper methods
extension InviteFriendsViewController {
    
    func initialSetup() {
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                if let name = userInfoModel.username, name != "" {
                    self.username = name + ", "
                }
            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }
        if let isContacts = UserDefaults.standard.value(forKey: UserDefaults.Keys.IsContacts.rawValue) as? Bool, isContacts {
            self.callGetInviteFriendsListApi()
        }else {
            self.tempFriends = SharedClass.sharedInstance.contacts
            self.searchFriendsArray = self.tempFriends
        }

    }
    
    func searchMyFavsByName(text: String) {
        print("Search:=====",text)
        let filtered = self.tempFriends.filter { ($0["name"]! as AnyObject).localizedCaseInsensitiveContains(text) }

        self.searchFriendsArray = filtered

        if text == "" {
            self.searchFriendsArray = self.tempFriends
        }
        
        self.tableView.reloadData()
    }
        
    // Fetch all contact from Phone
    func fetchAllContactFromPhoneForFilterContact() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }
        
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as NSString, CNContactFamilyNameKey as NSString, CNContactPhoneNumbersKey as NSString])

        
        self.mobileArray = []
        self.friendContact = []
        self.tempFriends = []
        self.searchFriendsArray = []

        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber {
                        // Get The Mobile Number
                        var mobile = number.stringValue
                        mobile = mobile.replacingOccurrences(of: " ", with: "")
                        mobile = mobile.replacingOccurrences(of: "(", with: "")
                        mobile = mobile.replacingOccurrences(of: ")", with: "")
                        mobile = mobile.replacingOccurrences(of: "-", with: "")
                        
                        self.mobileArray.append(mobile)
                        print(mobile)
                        
                        var image = UIImage()
                        var dict = Dictionary<String, Any>()
                        
                        dict["mobile"] = mobile
                        
//                        if let imageData = contact.imageData {
//                            if let myImage = UIImage(data: imageData) {
//                                image = myImage
//                                dict["image"] = image
//                            }
//                        }
                        dict["name"] = contact.givenName
                        self.friendContact.append(dict)
                    }
                }
                
                let filteredArray = self.friendContact.filter{ self.friendList.contains($0["mobile"] as! String) }
                SharedClass.sharedInstance.contacts = filteredArray
                self.tempFriends = filteredArray
                self.searchFriendsArray = filteredArray

                self.noDataMessage = "No data available"
                UserDefaults.standard.set(false, forKey: UserDefaults.Keys.IsContacts.rawValue)
                UserDefaults.standard.synchronize()

                self.tableView.reloadData()
            }
        } catch {
            print("unable to fetch contacts")
        }
        
    }
    
    // MARK: - Webservice methods
    func callGetInviteFriendsListApi() {
        
        let url = BaseUrl + kGetInviteFriendListApi
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(InviteFriendListModel.self, from: data)
                        if modelObj.success == true {
                            self.friendList = modelObj.data?.inviteList ?? []
                            print("Friend list:====", self.friendList)
                            self.fetchAllContactFromPhoneForFilterContact()
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
    
    // Fetch all contact from Phone
    func fetchAllContactFromPhone() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }
        
        hud.label.text = "Syncing contacts to fetch your recommended friends on MyFavs!"
        hud.isUserInteractionEnabled = false
        window.isUserInteractionEnabled = false
        
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as NSString, CNContactFamilyNameKey as NSString, CNContactPhoneNumbersKey as NSString])

        
        var mobileArray = [String]()
        
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber {
                        // Get The Mobile Number
                        var mobile = number.stringValue
                        mobile = mobile.replacingOccurrences(of: " ", with: "")
                        mobile = mobile.replacingOccurrences(of: "(", with: "")
                        mobile = mobile.replacingOccurrences(of: ")", with: "")
                        mobile = mobile.replacingOccurrences(of: "-", with: "")
                        
                        mobileArray.append(mobile)
                    }
                }
            }
            MBProgressHUD.hide(for: view, animated: true)
            window.isUserInteractionEnabled = true
            self.callSyncContactApi(phonebook: mobileArray)
        } catch {
            print("unable to fetch contacts")
            MBProgressHUD.hide(for: view, animated: true)
            window.isUserInteractionEnabled = true
        }
        
    }
    
    // Sync contact api
    func callSyncContactApi(phonebook: [String]) {
        
        var phoneArray = phonebook
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                if let number = userInfoModel.mobilenumber, number != "" {
                    
                    let filtered = phonebook.filter { $0 != number }
                    print(filtered)
                    phoneArray = filtered
                }
            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }

        let url = BaseUrl + kSyncContactApi
        let parameters: [String: Any] = ["phonebook": phoneArray]

        APIService.sharedInstance.postDataOnServerByAccessToken(loadingText: "Syncing contacts to fetch your recommended friends on MyFavs!", url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(ContactModel.self, from: data)
                        
                        if modelObj.success == true {
                            self.callGetInviteFriendsListApi()
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

//MARK: MFMessageComposeViewControllerDelegate methods
extension InviteFriendsViewController : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
}

// MARK: - UITextFieldDelegate methods
extension InviteFriendsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            view.endEditing(true)
            return false
        }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                self.searchMyFavsByName(text: String(textField.text!.dropLast()))
            }else {
                self.searchMyFavsByName(text: (textField.text ?? "") + string)
            }
        }
        
        return true
    }
    
}

//MARK: UITableViewDelegate, UITableViewDataSource methods
extension InviteFriendsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if self.searchFriendsArray.count > 0 {
            numOfSections            = 1
            tableView.backgroundView = nil
            return numOfSections
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
        //        if self.selectedIndex == 0 {
        //            if self.pendingRequest.count > 0 {
        //                return self.pendingRequest[0].requesters?.count ?? 0
        //            }
        //        }else {
        //            if self.pendingResponse.count > 0 {
        //                return self.pendingResponse[0].recipients?.count ?? 0
        //            }
        //
        //        }
        return self.searchFriendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendTableViewCell") as! InviteFriendTableViewCell
        
        cell.statusButton.backgroundColor = .red
        cell.statusButton.tag = indexPath.row
        cell.crossButton.tag = indexPath.row
        cell.crossButton.isHidden = true
        
        let friendObj = self.searchFriendsArray[indexPath.row]
        if let name = friendObj["name"] as? String, name != "" {
            cell.nameLabel.text = name
        }else {
            cell.nameLabel.text = friendObj["mobile"] as? String
        }
        
        if let image = friendObj["image"] as? UIImage {
            cell.userImageView.image = image
        }else {
            cell.userImageView.image = UIImage.init(named: "userPlaceholder")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: PendingTableViewCell
class InviteFriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
}

