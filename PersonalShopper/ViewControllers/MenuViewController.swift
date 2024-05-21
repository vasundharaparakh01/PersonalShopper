//
//  MenuViewController.swift
//  appName
//
//  Created by iOS Dev on 13/06/22.
//

import UIKit
import SDWebImage

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var itemsArry = Array<String>()
    lazy var homeVC: UIViewController = UINavigationController(rootViewController: mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
    lazy var profileVC: UIViewController = UINavigationController(rootViewController: mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController)
    lazy var settingsVC: UIViewController = UINavigationController(rootViewController: mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController)
    lazy var notificationsVC: UIViewController = UINavigationController(rootViewController: mainStoryboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController)
    lazy var termsVC: UIViewController = UINavigationController(rootViewController: mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
    
    //MARK: View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemsArry = ["Home", "Profile", "Invite Friends", "Notifications", "Terms and Conditions", "Settings"]
        self.bgImageView.transform = self.bgImageView.transform.rotated(by: CGFloat(Double.pi))
        self.menuSetup()
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)

                self.nameLabel.text = userInfoModel.username
                
                if let imageUrl = userInfoModel.profilePic {
                    self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
                }
            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }

//        self.callGetProfileApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainView.roundCorners(corners: [.topRight, .bottomRight], radius: 60.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIButtonActions
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        self.logout()
    }

    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}

//MARK: Helper methods
extension MenuViewController {
    
    func menuSetup() {
        
//        let profileVC =
//        self.profileVC =
//
//        let settingsVC =
//        self.settingsVC =
//
//        let notificationsVC =
//        self.notificationsVC =
//
//        let termsVC =
//        self.termsVC =
        
    }
    
    func logout() {
        AlertController.alert(title: appName, message: logOutSubTitle, buttons: ["No","Yes"]) { (UIAlertAction, indexSelected) in
            if indexSelected == 0 {
                
            }else {
                // Google logout
                //                GIDSignIn.sharedInstance.signOut()
                self.callSignoutApi()
            }
        }
    }
    
    // MARK: - Webservice methods
//    func callGetProfileApi() {
//
//        let url = BaseUrl + kGetProfileApi
//
//        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view, callback: { success, response, responseJson, errorMsg  in
//            if success {
//                if let data = response {
//                    do {
//                        let modelObj = try JSONDecoder().decode(ProfileModel.self, from: data)
//                        if modelObj.success == true {
//                            print(modelObj)
//                            do {
//                                // Encode Note
//                                let userInfoData = try JSONEncoder().encode(modelObj.data)
//
//                                // Write/Set Data
//                                UserDefaults.standard.set(userInfoData, forKey: UserDefaults.Keys.UserInfo.rawValue)
//                                UserDefaults.standard.synchronize()
//
//                                self.nameLabel.text = modelObj.data?.username
//
//                                if let imageUrl = modelObj.data?.profilePic {
//                                    self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                                    self.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
//                                }
//                            } catch {
//                                print("Unable to Encode Note (\(error))")
//                            }
//                        }else {
//                            if modelObj.message == sessionExpiredCheckMsg {
//                                AlertController.alert(title: sessionExpiredTitle, message: sessionExpiredSubTitle, buttons: ["Ok"]) { UIAlertAction, selectedIndex in
//                                    SharedClass.sharedInstance.gotoLogin(view: self.view)
//                                }
//                            }else {
//                                self.showAlert(withTitle: appName, withMessage: modelObj.message ?? kSomethingWentWrong)
//                            }
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//        })
//
//    }
    
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

//MARK: UITableViewDataSource & UITableViewDelegate methods
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        cell.notificationCountButton.isHidden = true
        cell.titelLabel.text! = itemsArry[indexPath.row]
        
        if indexPath.row == 3 {
            
            if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
                do {
                    // Decode Data
                    let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)

                    if let notification = userInfoModel.notificationCount, notification > 0 {
                        cell.notificationCountButton.isHidden = false
                        cell.notificationCountButton.setTitle("\(notification)", for: .normal)
                    }
                } catch {
                    print("Unable to Encode Note (\(error))")
                }
                
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let screenName = UserDefaults.standard.value(forKey: UserDefaults.Keys.ScreenName.rawValue) as? String else {return}
        
        switch indexPath.row {
        case 0:
            
            if screenName == ScreenType.home {
                self.dismiss(animated: true)
            }else {
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let delegate = windowScene.delegate as? SceneDelegate else { return }
                
                delegate.navController = UINavigationController(rootViewController: vc)
                delegate.navController.isNavigationBarHidden = true
                delegate.window?.rootViewController = delegate.navController
                delegate.window?.makeKeyAndVisible()
            }
            break
        case 1:
            if screenName == ScreenType.profile {
                self.dismiss(animated: true)
            }else {
                let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                //                UIApplication.shared.windows.first?.rootViewController = vc
                //                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let delegate = windowScene.delegate as? SceneDelegate else { return }
                
                delegate.navController = UINavigationController(rootViewController: vc)
                delegate.navController.isNavigationBarHidden = true
                delegate.window?.rootViewController = delegate.navController
                delegate.window?.makeKeyAndVisible()
            }
            break
//        case 2:
//            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true)
//            break
        case 2:
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "InviteFriendsViewController") as! InviteFriendsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            break
        case 3:
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            break
        case 4:
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "TermsConditionsViewController") as! TermsConditionsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            break
        case 5:
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            break
        default:
            break
        }
        
    }
    
}

//MARK: MenuTableViewCell
class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var notificationCountButton: UIButton!
    
}
