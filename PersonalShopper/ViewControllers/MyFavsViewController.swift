//
//  MyFavsViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 14/06/22.
//

import UIKit
import SideMenu
import SDWebImage


class MyFavsViewController: UIViewController {
    
    @IBOutlet weak var myFavsCollectionView: UICollectionView!
    @IBOutlet weak var notificationBadgeView: UIView!

    var favsArray = [GetAllProductModelDataItems]()
    var searchFavsArray = [GetAllProductModelDataItems]()
    let refreshControl = RefreshControl()


    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetup()
        
        self.myFavsCollectionView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshControl.endRefreshing()
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
        UserDefaults.standard.set(ScreenType.favourite, forKey: UserDefaults.Keys.ScreenName.rawValue)
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
    
    @IBAction func uploadButtonAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MyFavsPopUpViewController") as! MyFavsPopUpViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func editButtonAction(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MyFavsPopUpViewController") as! MyFavsPopUpViewController
        vc.delegate = self

        vc.isEdit = true
        vc.favsModel = self.searchFavsArray[sender.tag]
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func deleteButtonAction(sender: UIButton) {
        AlertController.alert(title: appName, message: deleteSubTitle, buttons: ["No","Yes"]) { (UIAlertAction, indexSelected) in
            
            if indexSelected == 0 {
                
            }else {
                self.callDeleteFavApi(id: self.searchFavsArray[sender.tag].id ?? "")
            }
        }

    }
    
    @objc func shareFavs(sender: UIButton) {
        
        let item = self.searchFavsArray[sender.tag]

        // Setting description
        var name = "I've added a new favorite to my wishlist!"
        var productUrl = ""
        if let nameStr = item.name {
            name = name + "\n\(nameStr)"
        }
        if let sizeType = item.sizeType {
            name = name + "\n\(sizeType):"
        }
        if let size = item.size {
            name = name + " \(size)"
        }
        if let location = item.location {
            name = name + "\n\(location)"
        }
        if let url = item.productlink {
            name = name + "\n\(url)"
            productUrl = url
        }
        name = name + "\nCheck out MYFAVS to shop the right sizes for your friends and family.\nDownload in Android\nhttps://play.google.com/store/apps/details?id=com.myfavs\nDownload in iOS"

        // If you want to use an image
        var itemImage = UIImage()
        
        if let imageObj = item.images?[0] {
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: imageObj.url!))
            itemImage = imageView.image ?? UIImage.init(named: "placeholder")!
        }

        let firstActivityItem = name
        let secondActivityItem : NSURL = NSURL(string: "https://apps.apple.com/us/app/myfavs/id1626843808")!
//        let thirdActivityItem = "\nDownload in Android\nhttps://play.google.com/store/apps/details?id=com.myfavs"

        let image : UIImage = itemImage
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
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

    }


}

// MARK: - Helper methods
extension MyFavsViewController {
    
    func initialSetup() {
        self.callGetFavApi()
    }

    func searchMyFavsByName(text: String) {
        print("Search:=====",text)
        let filtered = self.favsArray.filter { $0.name!.localizedCaseInsensitiveContains(text) }

        self.searchFavsArray = filtered

        if text == "" {
            self.searchFavsArray = self.favsArray
        }
        
        self.myFavsCollectionView.reloadData()
    }
    
    // MARK: - Webservice methods
    func callGetFavApi() {
        
        let url = BaseUrl + kGetProductApi
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(GetAllProductModel.self, from: data)
                        if modelObj.success == true {
                            self.favsArray = modelObj.data?.items ?? []
                            self.searchFavsArray = self.favsArray
                            self.myFavsCollectionView.reloadData()
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
    
    func callDeleteFavApi(id: String) {
        
        let url = BaseUrl + kDeleteProductApi + id
        
        APIService.sharedInstance.deleteDataOnServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(DeleteProductModel.self, from: data)
                        if modelObj.success == true {
                            self.callGetFavApi()
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

// MARK: - UITextFieldDelegate methods
extension MyFavsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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

// MARK: - UICollectionViewDelegatem & UICollectionViewDataSource methods
extension MyFavsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchFavsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavsCollectionViewCell", for: indexPath) as! FavsCollectionViewCell
        
        cell.deleteButton.tag = indexPath.item
        cell.shareButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction(sender:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(self.shareFavs(sender:)), for: .touchUpInside)

        let item = self.searchFavsArray[indexPath.item]
        
        cell.itemNameLabel.text = item.name
        if let images = item.images {
            if images.count > 0 {
                if let imageUrl = images[0].url {
                    cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
                }
            }
        }

        cell.editButton.tag = indexPath.item
        cell.editButton.addTarget(self, action: #selector(self.editButtonAction(sender:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/2 - 10, height: 196.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "FavsDetailsViewController") as! FavsDetailsViewController
        vc.favsModel = self.searchFavsArray[indexPath.item]
//        vc.categoryArray = self.categoryArray
//        vc.selectedIndex = 0
//        vc.isFromHome = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

extension MyFavsViewController: MyFavsPopUpViewDelegate {
    
    func dismissMyFavsPopUp() {
        self.callGetFavApi()
    }
    
}
