//
//  NotificationsViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 18/07/22.
//

import UIKit
import SideMenu

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var notificationArray = [NotificationsModelData]()
    var noDataMessage = ""

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
    //        UserDefaults.standard.set(ScreenType.notifications, forKey: UserDefaults.Keys.ScreenName.rawValue)
    //    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

//MARK: Helper methods
extension NotificationsViewController {
    
    func initialSetup() {
        self.callGetNotificationsApi()
    }
    
    func formatDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: date) ?? Date()
    }
    
    // MARK: - Webservice methods
    func callGetNotificationsApi() {
        
        let url = BaseUrl + kGetNotificationsApi
        self.noDataMessage = ""

        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(NotificationsModel.self, from: data)
                        if modelObj.success == true {
                            self.notificationArray = modelObj.data ?? [
                            ]
                            self.noDataMessage = "No notifications available"
                            self.tableView.reloadData()
                            self.callGetProfileApi()
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
    
    func callGetProfileApi() {
        
        let url = BaseUrl + kGetProfileApi
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view, callback: { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(ProfileModel.self, from: data)
                        if modelObj.success == true {
                            print(modelObj)
                            do {
                                // Encode Note
                                let userInfoData = try JSONEncoder().encode(modelObj.data)
                                
                                // Write/Set Data
                                UserDefaults.standard.set(userInfoData, forKey: UserDefaults.Keys.UserInfo.rawValue)
                                if let notification = modelObj.data?.notificationCount, notification > 0 {
                                    UserDefaults.standard.set(true, forKey: "IsNotification")
                                }else {
                                    UserDefaults.standard.set(false, forKey: "IsNotification")
                                }
                                UserDefaults.standard.synchronize()
                            } catch {
                                print("Unable to Encode Note (\(error))")
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
        })
        
    }

}

//MARK: UITableViewDelegate, UITableViewDataSource methods
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if self.notificationArray.count > 0 {
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
        return self.notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell") as! NotificationsTableViewCell
        
        let notification = self.notificationArray[indexPath.row]
        
        cell.titleLabel.text = notification.body
        
        if let date = notification.updatedAt {
            let datestr = self.formatDate(date: date)
            let timeAgoFormat = datestr.timeAgoDisplay()
            cell.timeLabel.text = timeAgoFormat
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notification = self.notificationArray[indexPath.row]
        if let type = notification.notificationType {

            if type == "1" || type == "3" {
                let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
                vc.friendId = notification.sender?.id ?? ""
                
//                vc.friendId = self.friendArray[indexPath.item].id ?? ""
                vc.isFriend = true
                //            UIApplication.shared.windows.first?.rootViewController = vc
                //            UIApplication.shared.windows.first?.makeKeyAndVisible()
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let delegate = windowScene.delegate as? SceneDelegate else { return }
                
                delegate.navController = UINavigationController(rootViewController: vc)
                delegate.navController.isNavigationBarHidden = true
                delegate.window?.rootViewController = delegate.navController
                //                delegate.window?.makeKeyAndVisible()
            }else if type == "2" {
                
                let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                
            }else if type == "4" {
                
//                let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
//                vc.friendId = notification.sender?.id ?? ""
//
////                vc.friendId = self.friendArray[indexPath.item].id ?? ""
//                vc.isFriend = false
//                //            UIApplication.shared.windows.first?.rootViewController = vc
//                //            UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                      let delegate = windowScene.delegate as? SceneDelegate else { return }
//
//                delegate.navController = UINavigationController(rootViewController: vc)
//                delegate.navController.isNavigationBarHidden = true
//                delegate.window?.rootViewController = delegate.navController
//                //                delegate.window?.makeKeyAndVisible()
                
            }
        }
        
    }
    
}


//MARK: NotificationsTableViewCell
class NotificationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}
