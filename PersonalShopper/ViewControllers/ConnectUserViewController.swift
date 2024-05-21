//
//  ConnectUserViewController.swift
//  appName
//
//  Created by iOS Dev on 17/06/22.
//

import UIKit
import SDWebImage
import SideMenu

class ConnectUserViewController: UIViewController {

    @IBOutlet weak var notificationBadgeView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!

    @IBOutlet weak var sizeCollectionView: UICollectionView!

    var prefferdSizeList = [PrefferedSizeModelData]()

    var page: Int = 1
    var isPageRefreshing:Bool = false
    var friendId = ""

    var suggestedUser: SuggestedUsersModelData?
//    var friendModel: Connections?
    var friendDetailsModel: FriendDetailsModelData?
    var isFriend = false
    var selectedIndex = 0
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetup()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
        UserDefaults.standard.set(ScreenType.addMember, forKey: UserDefaults.Keys.ScreenName.rawValue)
    }

    // MARK: - UIButtonActions
    @IBAction func categorySegmentAction(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        if self.selectedIndex == 0 {
            self.sizeView.isHidden = true
            self.categoryCollectionView.isHidden = false
        }else {
            self.sizeView.isHidden = false
            self.categoryCollectionView.isHidden = true
        }
    }

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
//        let vc = story.instantiateViewController(withIdentifier: "appNameViewController") as! appNameViewController
        let vc = TabBarVCShared.shared.appNameVC
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
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = TabBarVCShared.shared.MyFriendsVC
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
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
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()


    }
    
    @IBAction func connectButtonAction(_ sender: Any) {
        if self.isFriend {
            self.callWithdrawConnectionRequestApi(id: self.friendId)
        }else {
            self.callSendConnectionRequestApi(connectionId: self.suggestedUser?.id ?? "")
        }
    }
    
    @IBAction func sizeButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MoreSizesViewController") as! MoreSizesViewController
        vc.friendId = self.friendId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)

    }

    @IBAction func reportUserButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ReportPopUpViewController") as! ReportPopUpViewController
        vc.reportId = self.friendId
        vc.isappName = false
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func reportappNameButtonAction(_ sender: UIButton) {
        let favs = self.friendDetailsModel?.items?[sender.tag]

        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ReportPopUpViewController") as! ReportPopUpViewController
        vc.reportId = favs?.id ?? ""
        vc.isappName = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }


    @objc func viewButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "FavsDetailsViewController") as! FavsDetailsViewController
        vc.favsModel = self.friendDetailsModel?.items?[sender.tag]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func gotoLinkButtonAction(_ sender: UIButton) {
        
        guard let url = URL(string: self.friendDetailsModel?.items?[sender.tag].productlink ?? "") else {
            showAlert(withTitle: appName, withMessage: "Product link not found")
          return //be safe
        }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else {
            self.showAlert(withTitle: appName, withMessage: "Link is broken.")
        }
    }

}

// MARK: - Helper methods
extension ConnectUserViewController {
    
    func initialSetup() {
        
        self.setSegmentControl()
        self.sizeView.isHidden = true
        self.categoryCollectionView.isHidden = false

        if self.isFriend {
            self.callGetFavApi(id: self.friendId)
            self.callGetSizePreferenceApi(page: self.page)
        }else {
            self.suggesstedUserSetup()
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
    
    func suggesstedUserSetup() {
        self.userNameLabel.text = self.suggestedUser?.username
        if let imageUrl = self.suggestedUser?.profilePic {
            self.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.userProfileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
        }
        self.headingLabel.text = "\(self.suggestedUser?.username ?? "")'s Favs"
//            self.connectButton.isHidden = false
//        self.sizeButton.isHidden = true
    }

    func friendsSetup() {
        self.userNameLabel.text = self.friendDetailsModel?.userDetail?.username
        if let imageUrl = self.friendDetailsModel?.userDetail?.profilePic {
            self.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.userProfileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
        }
        self.headingLabel.text = "\(self.friendDetailsModel?.userDetail?.username ?? "")'s Favs"
//            self.connectButton.isHidden = true
        self.connectButton.setTitle("Disconnect", for: .normal)
//        self.sizeButton.isHidden = false
        self.categoryCollectionView.reloadData()
    }
            
    // MARK: - Webservice methods
    func callSendConnectionRequestApi(connectionId: String) {
        
        let url = BaseUrl + kSendConnectionRequestApi
        let parameters: [String: Any] = ["connectionId": connectionId]

        APIService.sharedInstance.postDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in

            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SendConnectionRequestModel.self, from: data)
                                                
                        if modelObj.success == true {
                            let story = UIStoryboard(name: "Main", bundle:nil)
                            let vc = TabBarVCShared.shared.MyFriendsVC
//                            UIApplication.shared.windows.first?.rootViewController = vc
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
    
    func callWithdrawConnectionRequestApi(id: String) {
        
        let url = BaseUrl + kWithdrawConnectionRequestApi + id
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(WithdrawnConnectionModel.self, from: data)
                        if modelObj.success == true {
                            AlertController.alert(title: appName, message: modelObj.message ?? kSomethingWentWrong, buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                
                                if selectedIndex == 0 {
                                    let story = UIStoryboard(name: "Main", bundle:nil)
                                    let vc = TabBarVCShared.shared.MyFriendsVC
                                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                                    delegate.navController = UINavigationController(rootViewController: vc)
                                    delegate.navController.isNavigationBarHidden = true
                                    delegate.window?.rootViewController = delegate.navController
                                    delegate.window?.makeKeyAndVisible()
                                }
                            }
                        }else {
                            AlertController.alert(title: appName, message: modelObj.message ?? kSomethingWentWrong, buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                
                                if selectedIndex == 0 {
                                    let story = UIStoryboard(name: "Main", bundle:nil)
                                    let vc = TabBarVCShared.shared.MyFriendsVC
                                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                        let delegate = windowScene.delegate as? SceneDelegate else { return }

                                    delegate.navController = UINavigationController(rootViewController: vc)
                                    delegate.navController.isNavigationBarHidden = true
                                    delegate.window?.rootViewController = delegate.navController
                                    delegate.window?.makeKeyAndVisible()
                                }
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }

    
    func callGetFavApi(id: String) {
        
        let url = BaseUrl + kGetProductFriendsFavApi + id
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(FriendDetailsModel.self, from: data)
                        if modelObj.success == true {
                            self.friendDetailsModel = modelObj.data
                            self.friendsSetup()
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

    func callGetSizePreferenceApi(page:Int) {
        
        var url = ""

        if self.friendId != "" {
            url = BaseUrl + kSizePreferenceApi + "?page=\(page)&size=\(30)&friendId=\(self.friendId)"

        }else {
            url = BaseUrl + kSizePreferenceApi + "?page=\(page)&size=\(30)"
        }

        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(PrefferedSizeModel.self, from: data)
                        if modelObj.success == true {
                            self.prefferdSizeList = modelObj.data ?? []
                            self.sizeCollectionView.reloadData()
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

// MARK: - UICollectionViewDelegatem & UICollectionViewDataSource methods
extension ConnectUserViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.categoryCollectionView {
            if self.isFriend {
                collectionView.restore()

                if self.friendDetailsModel?.items?.count == 0 {
                    collectionView.setEmptyMessage("No \(self.friendDetailsModel?.userDetail?.username ?? "")'s Favs")
                }
                return self.friendDetailsModel?.items?.count ?? 0
            }else {
                collectionView.setEmptyMessage("Connect with the user to view their favs")
                return 0
            }
        }else {
            if self.isFriend {
                collectionView.restore()
                if self.prefferdSizeList.count == 0 {
                    collectionView.setEmptyMessage("No data available")
                }
                return self.prefferdSizeList.count
            }else {
                collectionView.setEmptyMessage("Connect with the user to view their size")
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavsCollectionViewCell", for: indexPath) as! FavsCollectionViewCell
            
            let favs = self.friendDetailsModel?.items?[indexPath.item]
            if favs?.images?.count ?? 0 > 0 {
                if let imageUrl = favs?.images?[0].url {
                    cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
                }
            }
            if let name = favs?.name {
                cell.itemNameLabel.text = name
            }

            cell.editButton.tag = indexPath.item
            cell.gotoLinkButton.tag = indexPath.item
            cell.reportButton.tag = indexPath.item
            cell.editButton.addTarget(self, action: #selector(self.viewButtonAction(_:)), for: .touchUpInside)
            cell.gotoLinkButton.addTarget(self, action: #selector(self.gotoLinkButtonAction(_:)), for: .touchUpInside)
            cell.reportButton.addTarget(self, action: #selector(self.reportappNameButtonAction(_:)), for: .touchUpInside)

            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell
            
            cell.itemUSLabel.text = "US: --"
            cell.itemUKLabel.text = "UK: --"

            let item = self.prefferdSizeList[indexPath.item]

            cell.itemNameLabel.text = item.name
            if let sizes = item.subsubCatPrefferedSize {
                if sizes.count > 0 {
                    if let sizeType = item.subsubCatPrefferedSize?[0].sizeType {
                        if sizeType == "US" {
                            cell.itemUSLabel.text = "US: \(item.subsubCatPrefferedSize?[0].size ?? "--")"
                        }else {
                            cell.itemUKLabel.text = "UK: \(item.subsubCatPrefferedSize?[0].size ?? "--")"
                        }
                    }
                    if sizes.count > 1 {
                        if let sizeType = item.subsubCatPrefferedSize?[1].sizeType {
                            if sizeType == "UK" {
                                cell.itemUKLabel.text = "UK: \(item.subsubCatPrefferedSize?[1].size ?? "--")"
                            }else {
                                cell.itemUSLabel.text = "US: \(item.subsubCatPrefferedSize?[1].size ?? "--")"
                            }
                        }
                    }
                }

            }
            
            if let imageUrl = item.image {
                cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.categoryCollectionView {
            return CGSize.init(width: collectionView.frame.width/2 - 10, height: 196.0)
        }else {
            return CGSize.init(width: collectionView.frame.width/4 - 8, height: (collectionView.frame.width/4 - 8) + 34)
        }

    }
    
}
