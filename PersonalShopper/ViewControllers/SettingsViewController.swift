//
//  SettingsViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 23/06/22.
//

import UIKit
import SideMenu
import MBProgressHUD
import Contacts

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!

    var settings = [String]()
    
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView.transform = self.bgImageView.transform.rotated(by: CGFloat(Double.pi))
        self.initialSetup()
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
//        UserDefaults.standard.set(ScreenType.settings, forKey: UserDefaults.Keys.ScreenName.rawValue)
//    }

    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func findMeButtonAction(_ sender: UISwitch) {
        self.callFindMeApi(findByMobile: sender.isOn)
    }
    
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        
        AlertController.alert(title: appName, message: logOutSubTitle, buttons: ["No","Yes"]) { (UIAlertAction, indexSelected) in
            
            if indexSelected == 0 {
                
            }else {
                // Google logout
//                GIDSignIn.sharedInstance.signOut()

//                Token.sharedInstance.tokenString = ""
//                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.Token.rawValue)
//                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.IsLogin.rawValue)
//                UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.UserInfo.rawValue)
//                UserDefaults.standard.synchronize()
                
                self.callSignoutApi()
                                
            }
        }
        
    }

}

// MARK: - Webservice methods
extension SettingsViewController {
    
    func initialSetup() {
        self.settings = ["Find me using my phone number.", "Sync Contacts", "Change Password", "Requests"]
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
        
//        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
//            contactStore.requestAccess(for: .contacts){succeeded, err in
//                guard err == nil && succeeded else{
//                    return
//                }
//                
//            }
//        }else if CNContactStore.authorizationStatus(for: .contacts) == .restricted {
//            NSLog("restricted")
//        }else if CNContactStore.authorizationStatus(for: .contacts) == .denied {
//            NSLog("denied")
//        }else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
//            NSLog("authorized")
//        }

        var contacts = [CNContact]()
        let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactPhoneNumbersKey,
                        CNContactEmailAddressesKey
                ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        var mobileArray = [String]()

        do {
            try contactStore.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
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
    
    // MARK: - Webservice methods
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
                        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsContacts.rawValue)
                        UserDefaults.standard.synchronize()

                        if modelObj.success == true {
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

    func callFindMeApi(findByMobile: Bool) {
        
        let url = BaseUrl + kFindMeApi
        let parameters: [String: Any] = ["findByMobile": findByMobile]

        APIService.sharedInstance.postDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in

            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(FindMeModel.self, from: data)
                                                
                        if modelObj.success == true {
                            print(modelObj)
                            UserDefaults.standard.set(modelObj.data?.findByMobile, forKey: UserDefaults.Keys.FindMe.rawValue)
                            UserDefaults.standard.synchronize()
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
    
    func callSignoutApi() {
        
        let url = BaseUrl + kAuth + kSignOutApi
        
        guard let fcmToken = UserDefaults.standard.value(forKey: kFcmToken) as? String else {
            showAlert(withTitle: appName, withMessage: kSomethingWentWrong)
            return
        }

        let parameters: [String: Any] = ["fcmToken": fcmToken]

        APIService.sharedInstance.postDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in

            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SignoutModel.self, from: data)
                                                
                        if modelObj.success == true {
                            // Reset User Defaults
                            UserDefaults.standard.reset()
                            UserDefaults.standard.synchronize()
                            
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            let navController = UINavigationController(rootViewController: vc)
                            navController.isNavigationBarHidden = true
//                            UIApplication.shared.windows.first?.rootViewController = navController
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                let delegate = windowScene.delegate as? SceneDelegate else { return }

                            delegate.navController = UINavigationController(rootViewController: vc)
                            delegate.navController.isNavigationBarHidden = true
                            delegate.window?.rootViewController = delegate.navController
                            delegate.window?.makeKeyAndVisible()

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
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as! SettingsTableViewCell
        
        cell.findMeButton.isHidden = true
        cell.rightArrowImageView.isHidden = false
        cell.titleLabel.text = self.settings[indexPath.row]
        if indexPath.row == 0 {
            cell.findMeButton.isHidden = false
            cell.rightArrowImageView.isHidden = true
            if let findMe = UserDefaults.standard.value(forKey: UserDefaults.Keys.FindMe.rawValue) as? Bool {
                cell.findMeButton.isOn = findMe
            }else {
                cell.findMeButton.isOn = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            self.fetchAllContactFromPhone()
            break
        case 2:
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
//            UIApplication.shared.windows.first?.rootViewController = vc
//            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            break
        case 3:
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            break
        default:
            break
        }
    }
    
}

//MARK: SettingsTableViewCell
class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var findMeButton: UISwitch!

}
