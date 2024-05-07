//
//  MoreFriendsViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 26/08/22.
//

import UIKit
import MBProgressHUD
import SDWebImage

class MoreFriendsViewController: UIViewController {

    @IBOutlet weak var notificationBadgeView: UIView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var noUserLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!

    var suggestedArray = [SuggestedUsersModelData]()
    var friendArray = [Connections]()

    var viewHeight : CGFloat = 0
    var count = 0
    var userArray = [UserListModelDataDocs]()
    var searchUserArray = [UserListModelDataDocs]()

    var isFriend = false
    
    var page: Int = 1
    var isPageRefreshing:Bool = false
    var noDataMessage = ""

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
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
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()
    }

    @IBAction func addButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = TabBarVCShared.shared.MyFriendsVC

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()
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

}

// MARK: - Helper methods
extension MoreFriendsViewController {
    
    func initialMethod() {
        if self.isFriend {
            self.headingLabel.text = "Friend List"
        }else {
            self.headingLabel.text = "Suggested"
        }
        self.callGetSuggestedFriendsApi(page: page, isFriend: self.isFriend)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.userCollectionView.contentOffset.y >= (self.userCollectionView.contentSize.height - self.userCollectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                print(page)
                page = page + 1
                self.callGetSuggestedFriendsApi(page: page, isFriend: self.isFriend)
            }
        }
    }

    func searchSubCategoryByName(text: String) {
        print("Search:=====",text)
//        let filtered = self.subCategoryArray.filter { $0.name!.contains(text) }
        let filtered = self.userArray.filter { $0.username.localizedCaseInsensitiveContains(text) }

        self.searchUserArray = filtered

        if text == "" {
            self.searchUserArray = self.userArray
        }
        
        if self.searchUserArray.count > 0 {
            self.noDataMessage = ""
        }else {
            self.noDataMessage = "No user found"
        }

        self.userCollectionView.reloadData()
    }

    // Fetch all contact from Phone
//    func fetchAllContactFromPhone() {
//
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }
//
//        hud.label.text = "Syncing contacts to fetch your recommended friends on MyFavs!"
//        hud.isUserInteractionEnabled = false
//        window.isUserInteractionEnabled = false
//
//        let contactStore = CNContactStore()
//        var contacts = [CNContact]()
//        let keys = [
//                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//                        CNContactPhoneNumbersKey,
//                        CNContactEmailAddressesKey
//                ] as [Any]
//        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
//
//        var mobileArray = [String]()
//
//        do {
//            try contactStore.enumerateContacts(with: request){
//                    (contact, stop) in
//                // Array containing all unified contacts from everywhere
//                contacts.append(contact)
//                for phoneNumber in contact.phoneNumbers {
//                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
//                        // Get The Mobile Number
//                        var mobile = number.stringValue
//                        mobile = mobile.replacingOccurrences(of: " ", with: "")
//                        mobile = mobile.replacingOccurrences(of: "(", with: "")
//                        mobile = mobile.replacingOccurrences(of: ")", with: "")
//                        mobile = mobile.replacingOccurrences(of: "-", with: "")
//
//                        mobileArray.append(mobile)
//                    }
//                }
//            }
//            MBProgressHUD.hide(for: view, animated: true)
//            window.isUserInteractionEnabled = true
//            self.callSyncContactApi(phonebook: mobileArray)
//        } catch {
//            print("unable to fetch contacts")
//            MBProgressHUD.hide(for: view, animated: true)
//            window.isUserInteractionEnabled = true
//        }
//
//    }

    // MARK: - Webservice methods
    func callGetSuggestedFriendsApi(page:Int, isFriend:Bool) {
        
        var url = ""

        if isFriend {
            url = BaseUrl + kFriendListApi + "?page=\(page)&limit=\(30)"
        }else {
            url = BaseUrl + kSuggestedFriendsApi + "?page=\(page)&limit=\(30)"
        }
        
        //http://localhost:9127/api/V1/user/friendList?page=1&limit=5
        //http://localhost:9127/api/V1/user/suggestedFriends?page=2&limit=10

        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(UserListModel.self, from: data)
                        if modelObj.success == true {
                            if let docs = modelObj.data?.docs {
                                for item in docs {
                                    self.userArray.append(item)
                                }
                            }
//                            self.userArray = modelObj.data?.docs ?? []
                            self.searchUserArray = self.userArray
                            if self.userArray.count > 0 {
                                self.noDataMessage = ""
                            }else {
                                self.noDataMessage = "No user found"
                            }
                            self.userCollectionView.reloadData()
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
//                self.callGetProfileApi()
            }
        }
        
    }
    
    
    // Sync contact api
//    func callSyncContactApi(phonebook: [String]) {
//
//        var phoneArray = phonebook
//
//        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
//            do {
//                // Decode Data
//                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
//                if let number = userInfoModel.mobilenumber, number != "" {
//
//                    let filtered = phonebook.filter { $0 != number }
//                    print(filtered)
//                    phoneArray = filtered
//                }
//            } catch {
//                print("Unable to Encode Note (\(error))")
//            }
//
//        }
//
//        let url = BaseUrl + kSyncContactApi
//        let parameters: [String: Any] = ["phonebook": phoneArray]
//
//        APIService.sharedInstance.postDataOnServerByAccessToken(loadingText: "Syncing contacts to fetch your recommended friends on MyFavs!", url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
//
//            if success {
//                if let data = response {
//                    do {
//                        let modelObj = try JSONDecoder().decode(ContactModel.self, from: data)
//
//                        if modelObj.success == true {
//                            self.callGetSuggestedUsersApi()
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
//        }
//
//    }
    
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
//                            self.friendArray = modelObj.data?.connections ?? []
//                            if self.friendArray.count > 0 {
//                                self.noFriendLabel.isHidden = true
//                            }
//                            self.friendListCollectionView.reloadData()
//
//                            do {
//                                // Encode Note
//                                let userInfoData = try JSONEncoder().encode(modelObj.data)
//
//                                // Write/Set Data
//                                UserDefaults.standard.set(userInfoData, forKey: UserDefaults.Keys.UserInfo.rawValue)
//                                UserDefaults.standard.synchronize()
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

}

// MARK: - UICollectionViewDelegatem & UICollectionViewDataSource methods
extension MoreFriendsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if self.searchUserArray.count > 0 {
            numOfSections            = 1
            userCollectionView.backgroundView = nil
            return numOfSections
        }
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: userCollectionView.bounds.size.width, height: userCollectionView.bounds.size.height))
        noDataLabel.text          = self.noDataMessage
        noDataLabel.font = UIFont.init(name: "Poppins-Regular", size: 15.0)
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        userCollectionView.backgroundView  = noDataLabel
        return numOfSections

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchUserArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as! FriendsCollectionViewCell
        
        cell.moreView.isHidden = true
        cell.itemImageView.isHidden = false
        cell.itemImageView.layer.cornerRadius = (collectionView.frame.width/4 - 15)/2
        cell.itemImageView.clipsToBounds = true

//            if viewHeight < 926 {
//                if indexPath.item == 7 {
//                    cell.moreView.isHidden = false
//                    cell.itemImageView.isHidden = true
//                }
//            }else {
//                if indexPath.item == 11 {
//                    cell.moreView.isHidden = false
//                    cell.itemImageView.isHidden = true
//                }
//            }

        let userObj = self.searchUserArray[indexPath.item]

        if let first = userObj.username.components(separatedBy: " ").first {
            cell.nameLabel.text = first
        }

        if let imageUrl = userObj.profilePic {
            cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/4 - 15, height: (collectionView.frame.width/4 - 15) + 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.isFriend {
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
            vc.friendId = self.friendArray[indexPath.item].id ?? ""
            vc.isFriend = true

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate else { return }

            delegate.navController = UINavigationController(rootViewController: vc)
            delegate.navController.isNavigationBarHidden = true
            delegate.window?.rootViewController = delegate.navController
            delegate.window?.makeKeyAndVisible()
        }else {
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
            vc.suggestedUser = self.suggestedArray[indexPath.item]
            vc.isFriend = false

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate else { return }

            delegate.navController = UINavigationController(rootViewController: vc)
            delegate.navController.isNavigationBarHidden = true
            delegate.window?.rootViewController = delegate.navController
            delegate.window?.makeKeyAndVisible()
        }

    }

}

// MARK: - UITextFieldDelegate methods
extension MoreFriendsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                self.searchSubCategoryByName(text: String(textField.text!.dropLast()))
            }else {
                self.searchSubCategoryByName(text: (textField.text ?? "") + string)
            }
        }
        
        return true
    }
    
}
