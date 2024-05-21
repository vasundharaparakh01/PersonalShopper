//
//  HomeViewController.swift
//  appName
//
//  Created by Chandani Barsagade on 5/31/22.
//

import UIKit
import SideMenu
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var notificationBadgeView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var category1Label: UILabel!
    @IBOutlet weak var category2Label: UILabel!
    @IBOutlet weak var category1ImageView: UIImageView!
    @IBOutlet weak var category2ImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = RefreshControl()
    var timer = Timer()
    var pageIndex : Int = 0
//    let arrPageImage = ["banner", "shoes", "jacket"]
    var bannerDataArray = [BannerImageDataModel]()
    var categoryArray = [CategoryDataModel]()
    var isFromNoti = false

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isContacts = UserDefaults.standard.value(forKey: UserDefaults.Keys.IsContacts.rawValue) as? Bool, isContacts {
            InviteContactManager.shared.fetchAllContactFromPhone()
        }
        self.hideKeyboardWhenTappedAround()
        self.initialMethod()
        if self.isFromNoti {
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PendingViewController") as! PendingViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        setUpRefreshController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenu = segue.destination as? SideMenuNavigationController else { return }
        UserDefaults.standard.set(ScreenType.home, forKey: UserDefaults.Keys.ScreenName.rawValue)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        self.bannerView.roundCorners(corners: [.topLeft, .topRight], radius: 50.0)
    }
    
    func setUpRefreshController() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc func refreshData(_ sender: Any) {
        // Perform tasks to refresh the data, such as fetching new data from a server
        // and reloading the table view

        // End the refreshing when the tasks are completed
        self.initialMethod()
        print("end refreshing...")
        refreshControl.endRefreshing()
    }
    
    // MARK: - UIButtonActions
    @IBAction func sideMenuButtonAction(_ sender: UIButton) {
        //        if let slideMenuController = self.slideMenuController() {
        //            slideMenuController.openLeft()
        //        }
        
        //        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        //        present(menu, animated: true, completion: nil)
        
    }
    
    @IBAction func sizingButtonAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "SizingViewController") as! SizingViewController
        vc.categoryArray = self.categoryArray
        vc.selectedIndex = 0
        vc.isFromHome = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func categoryButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//        vc.sizeText = "\(self.categoryArray[0].name ?? "Men")'s Size"
//        vc.isWomenMen = false
//        vc.catId = self.categoryArray[0].id ?? ""
        
        
        vc.categoryArray = self.categoryArray
        vc.selectedIndex = sender.tag - 100
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)

    }
    
//    @IBAction func womenButtonAction(_ sender: Any) {
//        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
////        self.navigationController?.pushViewController(vc, animated: true)
//        vc.sizeText = "\(self.categoryArray[1].name ?? "Women")'s Size"
////        vc.isWomenMen = true
//        vc.catId = self.categoryArray[1].id ?? ""
//
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true)
//
//    }
    
    @IBAction func heartButtonAction(_ sender: Any) {
        
        let story = UIStoryboard(name: "Main", bundle:nil)
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
    
}

// MARK: - Helper methods
extension HomeViewController {
    
    func initialMethod() {
        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsLogin.rawValue)
        UserDefaults.standard.synchronize()

        var catId = "0"
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Encode Note
                let userInfoData = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                print(userInfoData)
                catId = "\(userInfoData.defaultBanner ?? 0)"
            } catch {
                print("Unable to Encode Note (\(error))")
            }

        }

        self.callGetBannerImageApi(catId: catId)
        self.callGetProfileApi()
    }
    
    func intiateBannerView() {
        
        pageController.numberOfPages = bannerDataArray[0].banner?.count ?? 0
//        pageController.numberOfPages = arrPageImage.count
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
        self.timer.invalidate()
        self.timer = Timer .scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(loadNextImage), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if (self.timer.isValid) {
            self.timer.invalidate()
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.stopTimer()
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                
                self.pageIndex = (pageIndex != 0) ? self.pageIndex - 1 : (bannerDataArray[0].banner?.count ?? 0) - 1
//                self.pageIndex = (pageIndex != 0) ? self.pageIndex - 1 : arrPageImage.count - 1
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
//                self.pageIndex = (pageIndex != self.arrPageImage.count-1) ? self.pageIndex + 1 : 0
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
                self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
            }

        }
        self.startTimer()
    }
    
    @objc func loadNextImage() {
        
        self.pageIndex = (pageIndex != (bannerDataArray[0].banner?.count ?? 0)-1) ? self.pageIndex + 1 : 0
//        self.pageIndex = (pageIndex != self.arrPageImage.count-1) ? self.pageIndex + 1 : 0
        self.pageController.currentPage = self.pageIndex
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.bannerView.layer.add(transition, forKey:"SwitchToView")
        
        if let imageUrl = self.bannerDataArray[0].banner?[pageIndex] as? String {
            self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        
    }
    
    
    // MARK: - Webservice methods
    func callGetBannerImageApi(catId: String) {
        
        let url = BaseUrl + kGetBannerImageByCatIdApi + catId
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                
                self.callGetCategoryApi()

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
    
    func callGetCategoryApi() {
        
        let url = BaseUrl + kGetCategoryApi
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(CategoryModel.self, from: data)
                        if modelObj.success == true {
                            self.categoryArray = modelObj.data ?? [
                            ]
                            if self.categoryArray.count > 0 {
                                self.category1Label.text = self.categoryArray[0].name
                                UserDefaults.standard.set(self.categoryArray[0].id, forKey: self.categoryArray[0].name!)
                                self.category1ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                                self.category1ImageView.sd_setImage(with: URL(string: (self.categoryArray[0].image)!), placeholderImage: UIImage.init(named: "men"))
                            }
                            if self.categoryArray.count > 1 {
                                self.category2Label.text = self.categoryArray[1].name
                                UserDefaults.standard.set(self.categoryArray[1].id, forKey: self.categoryArray[1].name!)

                                self.category2ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                                self.category2ImageView.sd_setImage(with: URL(string: (self.categoryArray[1].image)!), placeholderImage: UIImage.init(named: "women"))
                            }
                            UserDefaults.standard.synchronize()
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
