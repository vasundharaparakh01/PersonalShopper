//
//  EditItemViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 17/06/22.
//

import UIKit
import SDWebImage

class EditItemViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpImageView: UIImageView!
    @IBOutlet weak var popUpTitleLabel: UILabel!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeTypeButton: UIButton!
    @IBOutlet weak var sizeButton: UIButton!

    var subCategoryData : SubCategoryDataModel?
    var subSubCategoryArray = [SubSubCategoryDataModel]()
    var subSubCategoryData : SubSubCategoryDataModel?

    var sizeFormats = [SizeFormats]()
    var sizeArray = [String]()
    
    var sizesTypeArray = [String]()
    var isUKSelected = false
    //    var sizeArray = [String]()
    var sizeValue = ""
    var sizeTypeValue = ""
    
    var popSizeValue = ""
    var popSizeTypeValue = ""
    
    var usSizeId = ""
    var ukSizeId = ""
    
    var isFriend = false
    var friendId = ""

//    var popSubSubCatId = ""

    let categoryDrop = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDrop
        ]
    }()
    
    //    var timer = Timer()
    //    var pageIndex : Int = 0
    //    let arrPageImage = ["banner", "shoes", "jacket"]
    //    var viewHeight : CGFloat = 0
    //    var categoryData : CategoryDataModel?
    
    //    var categoryArray = [CategoryDataModel]()
    //    var selectedIndex = 0
    //    var bannerDataArray = [BannerImageDataModel]()
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.popUpView.isHidden = true
        self.popSizeTypeValue = ""
        self.popSizeValue = ""
        self.usSizeId = ""
        self.ukSizeId = ""
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if self.popSizeTypeValue == "" {
            self.showToast(message: "Please select size type", font: UIFont.systemFont(ofSize: 12.0))
            return
        }
        if self.popSizeValue == "" {
            self.showToast(message: "Please select size", font: UIFont.systemFont(ofSize: 12.0))
            return
        }
        
        var userId = ""
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                if let id = userInfoModel.id {
                    userId = id
                }
            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }
        
        if self.popSizeTypeValue == "US" && self.usSizeId != "" {
            self.callUpdatePreferedSizeApi(size: self.popSizeValue, subsubcatId: self.subSubCategoryData?.id ?? "", sizeType: self.popSizeTypeValue, userId: userId, id: self.usSizeId)
        }else if self.popSizeTypeValue == "UK" && self.ukSizeId != "" {
            self.callUpdatePreferedSizeApi(size: self.popSizeValue, subsubcatId: self.subSubCategoryData?.id ?? "", sizeType: self.popSizeTypeValue, userId: userId, id: self.ukSizeId)
        }else {
            self.callSavePreferedSizeApi(size: self.popSizeValue, subsubcatId: self.subSubCategoryData?.id ?? "", sizeType: self.popSizeTypeValue, userId: userId)
        }
        
    }
    
    @objc func usButtonAction(_ sender: UIButton) {
        self.isUKSelected = false
        self.sizeTypeValue = "US"
        
        let indexPosition = IndexPath(row: sender.tag, section: 0)
        self.tableView.reloadRows(at: [indexPosition], with: .none)
    }
    
    @objc func euButtonAction(_ sender: UIButton) {
        self.isUKSelected = true
        self.sizeTypeValue = "UK"
        
        let indexPosition = IndexPath(row: sender.tag, section: 0)
        self.tableView.reloadRows(at: [indexPosition], with: .none)
    }
    
//    @objc func editButtonAction(_ sender: UIButton) {
//        self.showAddSizePopUp(index: sender.tag)
//    }
    
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
        //
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
        //
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
        //
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.navController = UINavigationController(rootViewController: vc)
        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()
        
        
    }
    @IBAction func editButtonAction(_ sender: UIButton) {
        self.showAddSizePopUp(index: sender.tag)
    }
    
    @IBAction func sizeTypeDropDownButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        
        self.categoryDrop.anchorView = sender
        self.categoryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        self.categoryDrop.dataSource.removeAll()
        
        if let sizeFormats = self.subSubCategoryData?.subCatId?.sizeFormats {
            self.sizeFormats = sizeFormats
            self.sizesTypeArray = sizeFormats.map({ $0.sizeType ?? "" })
        }
        self.categoryDrop.dataSource = self.sizesTypeArray
        
        // Action triggered on selection
        self.categoryDrop.selectionAction = { [unowned self] (index, item) in
            
            sender.setTitle("  " + item, for: .normal)
            print("\(index)")
            self.popSizeTypeValue = item
        }
        self.categoryDrop.show()
        
    }
    
    @IBAction func sizeDropDownButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)

        if self.popSizeTypeValue == "" {
            self.showToast(message: "Please select size type", font: UIFont.systemFont(ofSize: 12.0))
            return
        }
        
        self.categoryDrop.anchorView = sender
        self.categoryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        self.categoryDrop.dataSource.removeAll()
        
        if let sizeFormats = self.subSubCategoryData?.subCatId?.sizeFormats {
            self.sizeFormats = sizeFormats
            self.sizesTypeArray = sizeFormats.map({ $0.sizeType ?? "" })
        }
        
        let sizeFormat = self.sizeFormats.filter{ ($0.sizeType?.contains(self.popSizeTypeValue))! }
        let sizeFormatObj = sizeFormat[0]
        //        if let sizeType = sizeFormatObj.sizeType {
        //            self.sizeTypeValue = sizeType
        //        }
        if let sizes = sizeFormatObj.sizes {
            self.sizeArray = sizes
        }

        self.categoryDrop.dataSource = self.sizeArray
        
        // Action triggered on selection
        self.categoryDrop.selectionAction = { [unowned self] (index, item) in
            
            sender.setTitle("  " + item, for: .normal)
            print("\(index)")
            self.popSizeValue = item
        }
        self.categoryDrop.show()
        
    }

    
//    @objc func dropDownButtonAction(_ sender: UIButton) {
//        self.view .endEditing(true)
//
//        self.categoryDrop.anchorView = sender
//        self.categoryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
//        self.categoryDrop.dataSource.removeAll()
//
//
//        let obj = self.subSubCategoryArray[sender.tag]
//        if let sizeFormats = obj.subCatId?.sizeFormats {
//            self.sizeFormats = sizeFormats
//            self.sizesTypeArray = sizeFormats.map({ $0.sizeType ?? "" })
//        }
//        let sizeFormat = self.sizeFormats.filter{ ($0.sizeType?.contains(self.sizeTypeValue))! }
//        let sizeFormatObj = sizeFormat[0]
//        //        if let sizeType = sizeFormatObj.sizeType {
//        //            self.sizeTypeValue = sizeType
//        //        }
//        if let sizes = sizeFormatObj.sizes {
//            self.sizeArray = sizes
//        }
//
//        self.categoryDrop.dataSource = self.sizeArray
//
//        // Action triggered on selection
//        self.categoryDrop.selectionAction = { [unowned self] (index, item) in
//
//            sender.setTitle("  " + item, for: .normal)
//            print("\(index)")
//
//            self.callSavePreferedSizeApi(size: item, subsubcatId: obj.id ?? "", sizeType: self.sizeTypeValue)
//        }
//        self.categoryDrop.show()
//
//    }
    
    
}

// MARK: - Helper methods
extension EditItemViewController {
    
    func initialSetup() {
        self.popUpView.isHidden = true

        //        self.sizeArray = ["S","M","L","XL","XXL"]
        self.sizeTypeValue = "US"
        self.titleLabel.text = self.subCategoryData?.name
        
        if let imageUrl = self.subCategoryData?.image as? String {
            self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }

        if self.isFriend {
            self.callGetSubSubCategoryByCatIdApi(userId: self.friendId)
        }else {
            var userId = ""
            
            if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
                do {
                    // Decode Data
                    let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                    if let id = userInfoModel.id {
                        userId = id
                    }
                } catch {
                    print("Unable to Encode Note (\(error))")
                }
                
            }
            self.callGetSubSubCategoryByCatIdApi(userId: userId)
        }
    }
    
    func showAddSizePopUp(index: Int) {
        self.usSizeId = ""
        self.ukSizeId = ""

        let obj = self.subSubCategoryArray[index]
        self.subSubCategoryData = obj
        self.popUpView.isHidden = false
        if let imageUrl = obj.image {
            self.popUpImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.popUpImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        if let name = obj.name {
            self.popUpTitleLabel.text = name
        }
        
        self.sizeButton.setTitle("Select size", for: .normal)
        self.sizeTypeButton.setTitle("Select size type", for: .normal)

        if let subsubCatPrefferedSize = obj.subsubCatPrefferedSize, subsubCatPrefferedSize.count > 0 {
            if subsubCatPrefferedSize.count > 1 {
                if let id = subsubCatPrefferedSize[0].id {
                    if subsubCatPrefferedSize[0].sizeType == "US" {
                        self.usSizeId = id
                    }else {
                        self.ukSizeId = id
                    }
                }
                if let id = subsubCatPrefferedSize[1].id {
                    if subsubCatPrefferedSize[1].sizeType == "UK" {
                        self.ukSizeId = id
                    }else {
                        self.usSizeId = id
                    }
                }
            }else if subsubCatPrefferedSize.count > 0 {
                if let id = subsubCatPrefferedSize[0].id {
                    if subsubCatPrefferedSize[0].sizeType == "US" {
                        self.usSizeId = id
                    }else {
                        self.ukSizeId = id
                    }
                }
            }
        }

    }
    
    //    func intiateBannerView() {
    //        pageController.numberOfPages = bannerDataArray[0].banner?.count ?? 0
    //        //set timer
    //        self.startTimer()
    //    }
    //
    //    func startTimer() {
    //        self.timer = Timer .scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(loadNextImage), userInfo: nil, repeats: true)
    //    }
    //
    //    func stopTimer() {
    //        if (self.timer.isValid) {
    //            self.timer.invalidate();
    //        }
    //    }
    //
    //    @objc func loadNextImage() {
    //
    //        self.pageIndex = (pageIndex != (bannerDataArray[0].banner?.count ?? 0)-1) ? self.pageIndex + 1 : 0
    //        self.pageController.currentPage = self.pageIndex
    //        let transition = CATransition()
    //        transition.duration = 0.5
    //        transition.type = CATransitionType.push
    //        transition.subtype = CATransitionSubtype.fromRight
    //        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
    //        self.bannerView.layer.add(transition, forKey:"SwitchToView")
    //        if let imageUrl = bannerDataArray[0].banner?[pageIndex] as? String {
    //            self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    //            self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
    //        }
    //
    //    }
    
    // MARK: - Webservice methods
    func callGetSubSubCategoryByCatIdApi(userId: String) {
        
//        let url = BaseUrl + kGetSubSubCategoryBySubCatIdApi + "\(self.subCategoryData?.id ?? "")"
        let url = BaseUrl + kGetSubSubCategoryBySubCatIdApi + "\(self.subCategoryData?.id ?? "")" + "?userId=\(userId)"

        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SubSubCategoryModel.self, from: data)
                        if modelObj.success == true {
                            self.subSubCategoryArray = modelObj.data ?? []
                            self.tableView.reloadData()
                            //                            self.subcategoryCollectionView.reloadData()
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
    
    func callSavePreferedSizeApi(size: String, subsubcatId: String, sizeType: String, userId: String) {
        
        let url = BaseUrl + kCreateSizePreferenceApi
        let parameters: [String: Any] = [
            "size":size,
            "subsubcatId":subsubcatId,
            "sizeType":sizeType,
            "userId":userId
        ]
        
        APIService.sharedInstance.postDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SavePreferedSizeModel.self, from: data)
                        
                        if modelObj.success == true {
                            AlertController.alert(title: appName, message: modelObj.message ?? "Successfully", buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                self.popUpView.isHidden = true
                                self.popSizeTypeValue = ""
                                self.popSizeValue = ""
                                
                                self.callGetSubSubCategoryByCatIdApi(userId: userId)
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
    
    func callUpdatePreferedSizeApi(size: String, subsubcatId: String, sizeType: String, userId: String, id: String) {
        
        let url = BaseUrl + kUpdateSizePreferenceApi + id
        
        let parameters: [String: Any] = [
            "size":size,
            "subsubcatId":subsubcatId,
            "sizeType":sizeType,
            "userId":userId
        ]
        
        APIService.sharedInstance.putDataOnServerByAccessToken(url: url, params: parameters, view: self.view) { success, response, responseJson, errorMsg  in
            
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SavePreferedSizeModel.self, from: data)
                        
                        if modelObj.success == true {
                            AlertController.alert(title: appName, message: modelObj.message ?? "Successfully", buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                self.popUpView.isHidden = true
                                self.popSizeTypeValue = ""
                                self.popSizeValue = ""
                                
                                self.callGetSubSubCategoryByCatIdApi(userId: userId)
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

    
    //    func callGetBannerImageApi(catId: String) {
    //
    //        let url = BaseUrl + kGetBannerImageByCatIdApi + catId
    //
    //        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
    //            if success {
    //
    //                if let data = response {
    //                    do {
    //                        let modelObj = try JSONDecoder().decode(BannerImageModel.self, from: data)
    //                        if modelObj.success == true {
    //                            self.bannerDataArray = modelObj.data ?? []
    //                            if self.bannerDataArray.count > 0 {
    //                                if (modelObj.data?[0].banner?.count)! > 0 {
    //                                    self.intiateBannerView()
    //                                }
    //                            }
    //                        }else {
    //                            self.showAlert(withTitle: appName, withMessage: modelObj.message ?? kSomethingWentWrong)
    //                        }
    //                    } catch {
    //                        print(error)
    //                    }
    //                }
    //            }
    //        }
    //
    //    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource methods
extension EditItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subSubCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
        
        let obj = self.subSubCategoryArray[indexPath.row]
        cell.itemNameLabel.text = obj.name ?? ""
        if let imageUrl = obj.image {
            cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        cell.itemNameLabel.text = obj.name
        cell.usButton.tag = indexPath.row
        cell.euButton.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        if self.isFriend {
            cell.editButton.isHidden = true
        }else {
            cell.editButton.isHidden = false
        }
        
        cell.euButton.isSelected = self.isUKSelected
        cell.usButton.isSelected = !cell.euButton.isSelected
        
        if let subsubCatPrefferedSize = obj.subsubCatPrefferedSize {
            cell.usSizeLabel.text = "--"
            cell.ukSizeLabel.text = "--"

            if subsubCatPrefferedSize.count > 1 {
                if let size = subsubCatPrefferedSize[0].size {
                    if subsubCatPrefferedSize[0].sizeType == "US" {
                        cell.usSizeLabel.text = size
                    }else {
                        cell.ukSizeLabel.text = size
                    }
                }
                if let size = subsubCatPrefferedSize[1].size {
                    if subsubCatPrefferedSize[1].sizeType == "UK" {
                        cell.ukSizeLabel.text = size
                    }else {
                        cell.usSizeLabel.text = size
                    }
                }
            }else if subsubCatPrefferedSize.count > 0 {
                if let size = subsubCatPrefferedSize[0].size {
                    if subsubCatPrefferedSize[0].sizeType == "US" {
                        cell.usSizeLabel.text = size
                    }else {
                        cell.ukSizeLabel.text = size
                    }
                }
            }

        }
        
        cell.usButton.addTarget(self, action: #selector(self.usButtonAction(_:)), for: .touchUpInside)
        cell.euButton.addTarget(self, action: #selector(self.euButtonAction(_:)), for: .touchUpInside)
//        cell.editButton.addTarget(self, action: #selector(self.editButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
}


//MARK: ItemTableViewCell
class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var usButton: UIButton!
    @IBOutlet weak var euButton: UIButton!
    @IBOutlet weak var usSizeLabel: UILabel!
    @IBOutlet weak var ukSizeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
}
