//
//  FriendsViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 24/06/22.
//

import UIKit
import SideMenu
import SDWebImage
import Contacts
import MBProgressHUD

class FriendsViewController: UIViewController {

    @IBOutlet weak var notificationBadgeView: UIView!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    @IBOutlet weak var friendListCollectionView: UICollectionView!
    @IBOutlet weak var noSuggestedLabel: UILabel!
    @IBOutlet weak var noFriendLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewHeight : CGFloat = 0
    var count = 0
    var suggestedArray = [SuggestedUsersModelData]()
    var friendArray = [Connections]()
    let refreshControl = RefreshControl()


    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialMethod()
        self.setUpRefreshControl()
    }
    
    func setUpRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)

                if let notification = userInfoModel.notificationCount, notification > 0 {
                    self.notificationBadgeView.isHidden = false
                }else {
                    self.notificationBadgeView.isHidden = true
                }
            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }

    }
    
    @objc func refreshData(_ sender: Any) {
        initialMethod()
        refreshControl.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
        UserDefaults.standard.set(ScreenType.addMember, forKey: UserDefaults.Keys.ScreenName.rawValue)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewHeight = self.view.frame.height
        if viewHeight < 926 {
            self.count = 8
        }else {
            self.count = 12
        }

//        self.categoryCollectionView.reloadData()
    }

    // MARK: - UIButtonActions
    @IBAction func homeButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let vc = TabBarVCShared.shared.HomeVC
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()

    }
    
    @IBAction func heartButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "MyFavsViewController") as! MyFavsViewController
        let vc = TabBarVCShared.shared.MyFavsVC
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()


    }

    @IBAction func addButtonAction(_ sender: Any) {
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = TabBarVCShared.shared.MyProfileVC
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()
    }

    @IBAction func syncContactButtonAction(_ sender: UIButton) {
        self.fetchAllContactFromPhone()
    }

}

// MARK: - Helper methods
extension FriendsViewController {
    
    func initialMethod() {
        self.callGetSuggestedUsersApi()
        
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
    func callGetSuggestedUsersApi() {
        
        let url = BaseUrl + kSuggestedUsersApi
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SuggestedUsersModel.self, from: data)
                        if modelObj.success == true {
                            self.suggestedArray = modelObj.data ?? []
                            if self.suggestedArray.count > 0 {
                                self.noSuggestedLabel.isHidden = true
                            }
                            self.suggestedCollectionView.reloadData()
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
                self.callGetProfileApi()
            }
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
                        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsContacts.rawValue)
                        UserDefaults.standard.synchronize()

                        if modelObj.success == true {
                            self.callGetSuggestedUsersApi()
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
                            self.friendArray = modelObj.data?.connections ?? []
                            if self.friendArray.count > 0 {
                                self.noFriendLabel.isHidden = true
                            }
                            self.friendListCollectionView.reloadData()

                            do {
                                // Encode Note
                                let userInfoData = try JSONEncoder().encode(modelObj.data)

                                // Write/Set Data
                                UserDefaults.standard.set(userInfoData, forKey: UserDefaults.Keys.UserInfo.rawValue)
                                if let notification = modelObj.data?.notificationCount, notification > 0 {
                                    UserDefaults.standard.set(true, forKey: "IsNotification")
                                    self.notificationBadgeView.isHidden = false
                                }else {
                                    UserDefaults.standard.set(false, forKey: "IsNotification")
                                    self.notificationBadgeView.isHidden = true
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

// MARK: - UICollectionViewDelegatem & UICollectionViewDataSource methods
extension FriendsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewHeight < 926 {
            if collectionView == self.suggestedCollectionView {
                if self.suggestedArray.count > 8 {
                    return 8
                }
                return self.suggestedArray.count
            }else {
                if self.friendArray.count > 8 {
                    return 8
                }
                return self.friendArray.count
            }
        }else {
            if collectionView == self.suggestedCollectionView {
                if self.suggestedArray.count > 12 {
                    return 12
                }
                return self.suggestedArray.count
            }else {
                if self.friendArray.count > 12 {
                    return 12
                }
                return self.friendArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.suggestedCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as! FriendsCollectionViewCell
            
            cell.moreView.isHidden = true
            cell.itemImageView.isHidden = false
            cell.nameLabel.isHidden = false
            cell.itemImageView.layer.cornerRadius = (collectionView.frame.width/4 - 15)/2
            cell.itemImageView.clipsToBounds = true
            
            let userObj = self.suggestedArray[indexPath.item]

            if let name = userObj.username {
                if let first = name.components(separatedBy: " ").first {
                    cell.nameLabel.text = first
                }
            }
            if let imageUrl = userObj.profilePic {
                cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
            }

            if viewHeight < 926 {
                if indexPath.item == 7 {
                    cell.moreView.isHidden = false
                    cell.itemImageView.isHidden = true
                    cell.nameLabel.isHidden = true
                }
            }else {
                if indexPath.item == 11 {
                    cell.moreView.isHidden = false
                    cell.itemImageView.isHidden = true
                    cell.nameLabel.isHidden = true
                }
            }

            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as! FriendsCollectionViewCell
            
            cell.moreView.isHidden = true
            cell.itemImageView.isHidden = false
            cell.nameLabel.isHidden = false
            cell.itemImageView.layer.cornerRadius = (collectionView.frame.width/4 - 15)/2
            cell.itemImageView.clipsToBounds = true
            
            if viewHeight < 926 {
                if indexPath.item == 7 {
                    cell.moreView.isHidden = false
                    cell.itemImageView.isHidden = true
                    cell.nameLabel.isHidden = true
                }
            }else {
                if indexPath.item == 11 {
                    cell.moreView.isHidden = false
                    cell.itemImageView.isHidden = true
                    cell.nameLabel.isHidden = true
                }
            }

            let userObj = self.friendArray[indexPath.item]
            
            if let name = userObj.username {
                if let first = name.components(separatedBy: " ").first {
                    cell.nameLabel.text = first
                }
            }

            if let imageUrl = userObj.profilePic {
                cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/4 - 15, height: (collectionView.frame.width/4 - 15) + 22)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
//
//        // Add your button here
//
//        return view
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.suggestedCollectionView {

            if viewHeight < 926 {
                if indexPath.item == 7 {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MoreFriendsViewController") as! MoreFriendsViewController
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    vc.suggestedArray = self.suggestedArray
                    vc.friendArray = self.friendArray
                    vc.isFriend = false
                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }else {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
                    vc.suggestedUser = self.suggestedArray[indexPath.item]
                    vc.friendId = self.suggestedArray[indexPath.item].id ?? ""

                    vc.isFriend = false

                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }
            }else {
                if indexPath.item == 11 {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MoreFriendsViewController") as! MoreFriendsViewController
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    vc.isFriend = false
                    vc.suggestedArray = self.suggestedArray
                    vc.friendArray = self.friendArray
                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }else {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
                    vc.suggestedUser = self.suggestedArray[indexPath.item]
                    vc.friendId = self.suggestedArray[indexPath.item].id ?? ""

                    vc.isFriend = false

                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }
            }
        }else {
            if viewHeight < 926 {
                if indexPath.item == 7 {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MoreFriendsViewController") as! MoreFriendsViewController
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    vc.suggestedArray = self.suggestedArray
                    vc.friendArray = self.friendArray
                    vc.isFriend = true
                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }else {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
                    vc.friendId = self.friendArray[indexPath.item].id ?? ""
                    vc.isFriend = true

                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }
            }else {
                if indexPath.item == 11 {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MoreFriendsViewController") as! MoreFriendsViewController
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    vc.suggestedArray = self.suggestedArray
                    vc.friendArray = self.friendArray
                    vc.isFriend = true
                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }else {
                    let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
                    vc.friendId = self.friendArray[indexPath.item].id ?? ""
                    vc.isFriend = true

                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                    delegate.navController = UINavigationController(rootViewController: vc)
                    delegate.navController.isNavigationBarHidden = true
                    delegate.window?.rootViewController = delegate.navController
                    delegate.window?.makeKeyAndVisible()
                }
            }
        }

    }
    
}

//MARK: CategoryCollectionViewCell
class FriendsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

}
