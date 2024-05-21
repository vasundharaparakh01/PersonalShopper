//
//  CategoryMenViewController.swift
//  appName
//
//  Created by iOS Dev on 15/06/22.
//

import UIKit
import SDWebImage
import SideMenu

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var notificationBadgeView: UIView!

    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var sizeLabel: UILabel!

    var timer = Timer()
    var pageIndex : Int = 0
//    let arrPageImage = ["banner", "shoes", "jacket"]
    var viewHeight : CGFloat = 0
    
    var subCategoryArray = [SubCategoryDataModel]()
//    var categoryData : CategoryDataModel?
    var categoryArray = [CategoryDataModel]()
    var selectedIndex = 0
    var bannerDataArray = [BannerImageDataModel]()
    var searchSubCategoryArray = [SubCategoryDataModel]()

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialMethod()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewHeight = self.view.frame.height
//        self.categoryCollectionView.reloadData()
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
        UserDefaults.standard.set(ScreenType.home, forKey: UserDefaults.Keys.ScreenName.rawValue)
    }

    // MARK: - UIButtonActions
    @IBAction func sizingButtonAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "SizingViewController") as! SizingViewController
        vc.categoryArray = self.categoryArray
        vc.selectedIndex = self.selectedIndex
        vc.isFromHome = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func seeAllButtonAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "AllCategoryViewController") as! AllCategoryViewController
        vc.subCategoryArray = self.subCategoryArray
        vc.categoryArray = self.categoryArray
        vc.selectedIndex = self.selectedIndex
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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

}

// MARK: - Helper methods
extension CategoryViewController {
    
    func initialMethod() {
        self.sizeLabel.text = "\(self.categoryArray[selectedIndex].name ?? "")"
//        self.intiateBannerView()
        self.callGetBannerImageApi(catId: self.categoryArray[selectedIndex].id ?? "")
        self.callGetSubCategoryByCatIdApi()
    }
    
    func intiateBannerView() {
        
        pageController.numberOfPages = bannerDataArray[0].banner?.count ?? 0
        //swipe gesture
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        //        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        //        self.headerView.addGestureRecognizer(swipeRight)
        //
        //        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        //        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        //        self.headerView.addGestureRecognizer(swipeLeft)
        
        //set timer
        
        if self.bannerDataArray[0].banner?.count ?? 0 > 0 {
            if let imageUrl = self.bannerDataArray[0].banner?[0] as? String {
                self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
            }
        }

        self.startTimer()
        
    }
    
    func startTimer() {
        self.timer = Timer .scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(loadNextImage), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if (self.timer.isValid) {
            self.timer.invalidate();
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.stopTimer()
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                
                self.pageIndex = (pageIndex != 0) ? self.pageIndex - 1 : (bannerDataArray[0].banner?.count ?? 0) - 1
                self.pageController.currentPage = self.pageIndex
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromLeft
                transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                self.bannerView.layer.add(transition, forKey:"SwitchToView")
                
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                
                self.pageIndex = (pageIndex != (bannerDataArray[0].banner?.count ?? 0)-1) ? self.pageIndex + 1 : 0
                self.pageController.currentPage = self.pageIndex
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                self.bannerView.layer.add(transition, forKey:"SwitchToView")
                
            default:
                break
            }
            
            if let imageUrl = bannerDataArray[0].banner?[pageIndex] as? String {
                self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
            }

//            self.bannerView.image = UIImage.init(named:(bannerDataArray[0].banner?[pageIndex])!)
        }
        self.startTimer()
    }
    
    @objc func loadNextImage() {
        
        self.pageIndex = (pageIndex != (bannerDataArray[0].banner?.count ?? 0)-1) ? self.pageIndex + 1 : 0
        self.pageController.currentPage = self.pageIndex
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.bannerView.layer.add(transition, forKey:"SwitchToView")
        
        if let imageUrl = bannerDataArray[0].banner?[pageIndex] as? String {
            self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }

//        self.bannerView.image = UIImage.init(named:(self.bannerDataArray[0].banner?[pageIndex])!)
        
    }
    
    func searchSubCategoryByName(text: String) {
        print("Search:=====",text)
//        let filtered = self.subCategoryArray.filter { $0.name!.contains(text) }
        let filtered = self.subCategoryArray.filter { $0.name!.localizedCaseInsensitiveContains(text) }

        self.searchSubCategoryArray = filtered

        if text == "" {
            self.searchSubCategoryArray = self.subCategoryArray
        }
        
        self.categoryCollectionView.reloadData()
    }
    
    // MARK: - Webservice methods
    func callGetSubCategoryByCatIdApi() {
        
        let url = BaseUrl + kGetSubCategoryByCatIdApi + "\(self.categoryArray[selectedIndex].id ?? "")"
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SubCategoryModel.self, from: data)
                        if modelObj.success == true {
                            self.subCategoryArray = modelObj.data ?? []
                            self.searchSubCategoryArray = self.subCategoryArray
                            self.categoryCollectionView.reloadData()
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
    
    func callGetBannerImageApi(catId: String) {
        
        let url = BaseUrl + kGetBannerImageByCatIdApi + catId
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(BannerImageModel.self, from: data)
                        if modelObj.success == true {
                            self.bannerDataArray = modelObj.data ?? []
                            if self.bannerDataArray.count > 0 {
                                if (modelObj.data?[0].banner?.count)! > 0 {
                                    self.intiateBannerView()
                                }
                            }
                        }else {
                            self.showAlert(withTitle: appName, withMessage: modelObj.message ?? kSomethingWentWrong)
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
extension CategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if viewHeight < 926 {
//            if self.subCategoryArray.count > 8 {
//                return 8
//            }
//        }else {
//            if self.subCategoryArray.count > 12 {
//                return 12
//            }
//        }
//        return self.subCategoryArray.count
        return self.searchSubCategoryArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        
        let obj = self.searchSubCategoryArray[indexPath.item]
        if let imageUrl = obj.image {
            cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        cell.itemNameLabel.text = obj.name

        cell.moreView.isHidden = true
        cell.itemImageView.isHidden = false
        cell.itemNameLabel.isHidden = false

//        if viewHeight < 926 {
//            if self.subCategoryArray.count > 8 {
//                if indexPath.item == 7 {
//                    cell.moreView.isHidden = false
//                    cell.itemImageView.isHidden = true
//                    cell.itemNameLabel.isHidden = true
//                }
//            }
//        }else {
//            if self.subCategoryArray.count > 12 {
//                if indexPath.item == 11 {
//                    cell.moreView.isHidden = false
//                    cell.itemImageView.isHidden = true
//                    cell.itemNameLabel.isHidden = true
//                }
//            }
//        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/4 - 15, height: collectionView.frame.width/4 + 15)
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
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
        vc.subCategoryData = self.searchSubCategoryArray[indexPath.item]
//        vc.categoryData = self.categoryArray[selectedIndex]
//        vc.categoryArray = self.categoryArray
//        vc.selectedIndex = self.selectedIndex
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate methods
extension CategoryViewController: UITextFieldDelegate {
    
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

//MARK: CategoryCollectionViewCell
class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var moreView: UIView!

}
