//
//  ProfileViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 10/06/22.
//

import UIKit
import SideMenu
import AVFoundation
import MBProgressHUD
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var notificationBadgeView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabelView: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var imagePicker = UIImagePickerController()
    var deviceAuthorized = Bool()
    var id = ""
    var profilePic: UIImage?
    var prefferdSizeList = [PrefferedSizeModelData]()
    var noDataMessage = ""
    let refreshControl = RefreshControl()

    //    var isEdit = false
    
    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialMethod()
        
        self.tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc func refreshData(_ sender: Any) {
        refreshControl.endRefreshing()
        self.callGetProfileApi()
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
        UserDefaults.standard.set(ScreenType.profile, forKey: UserDefaults.Keys.ScreenName.rawValue)
    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.editButton.isHidden = true
        self.cancelButton.isHidden = false
        self.saveButton.isHidden = false
        self.profileImageButton.isEnabled = true
        self.saveButton.isEnabled = false
        self.saveButton.backgroundColor = hexStringToUIColor(hex: "#76CEA1", a: 0.19)
        
        self.aboutView.isHidden = false
        self.aboutLabelView.isHidden = true

        self.numberTextField.isUserInteractionEnabled = true
        self.userNameTextField.isUserInteractionEnabled = true
        self.aboutTextView.placeholder = "Enter here"

        if self.aboutLabel.text?.trimWhiteSpace == "" {
            self.aboutTextView.placeholder = "Enter here"
        }else {
            self.aboutTextView.text = self.aboutLabel.text
        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.setupUIMethod()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        let validated = self.isValidateAllFields()
        if validated.isValidate {
            if self.profilePic == nil {
                self.callUpdateProfileApi(username: self.userNameTextField.text?.trimWhiteSpace ?? "", mobileNumber: self.numberTextField.text?.trimWhiteSpace ?? "", about: self.aboutTextView.text)
            }else {
                self.callUpdateProfileWithImageApi(profilePic: self.profilePic!, username: self.userNameTextField.text?.trimWhiteSpace ?? "", mobileNumber: self.numberTextField.text?.trimWhiteSpace ?? "", about: self.aboutTextView.text)
            }
        }else {
            self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
        }
    }
    
    @IBAction func addPhotoButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.editButton.isHidden = true
        self.cancelButton.isHidden = false
        self.saveButton.isHidden = false
        self.profileImageButton.isEnabled = true
        self.saveButton.isEnabled = false
        self.saveButton.backgroundColor = hexStringToUIColor(hex: "#76CEA1", a: 0.19)
        
        self.aboutView.isHidden = false
        self.aboutLabelView.isHidden = true

        self.numberTextField.isUserInteractionEnabled = true
        self.userNameTextField.isUserInteractionEnabled = true
        self.aboutTextView.placeholder = "Enter here"

        if self.aboutLabel.text?.trimWhiteSpace == "" {
            self.aboutTextView.placeholder = "Enter here"
        }else {
            self.aboutTextView.text = self.aboutLabel.text
        }

        if self.deviceAuthorized {
            self.profileImagePickerSheet()
        }else {
            self.presentCameraSettings()
        }
    }
    
    // Tabbar buttons
    @IBAction func homeButtonAction(_ sender: Any) {
        self.view.endEditing(true)
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
        self.view.endEditing(true)
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
    
    @IBAction func heartButtonAction(_ sender: Any) {
        self.view.endEditing(true)
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
    
    
}

// MARK: - Helper methods
extension ProfileViewController {
    
    func initialMethod() {
        self.checkForAuthorizationStatus()
        if let _ = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) {
            self.setupUIMethod()
        } else {
            self.callGetProfileApi()
        }
        
        if let modelObj = UserDefaults.standard.data(forKey: "UserPrefferedSizeModel") {
            let decoder = JSONDecoder()
            if let modelObj = try? decoder.decode(PrefferedSizeModel.self, from: modelObj) {
                if modelObj.success == true {
                    self.prefferdSizeList = modelObj.data ?? []
                    if self.prefferdSizeList.count > 0 {
                        self.noDataMessage = ""
                    }else {
                        self.noDataMessage = "No preferred sizes available"
                    }
                    self.sizeCollectionView.reloadData()
                }
            }
        } else {
            self.callGetSizePreferenceApi(page: 1)
        }
        
    }
    
    func setupUIMethod() {
        
        self.editButton.isHidden = false
        self.cancelButton.isHidden = true
        self.saveButton.isHidden = true
        self.profileImageButton.isEnabled = false
        self.saveButton.isEnabled = false
        self.saveButton.backgroundColor = hexStringToUIColor(hex: "#76CEA1", a: 0.19)
        
        self.aboutView.isHidden = true
        self.aboutLabelView.isHidden = false

        self.emailTextField.isUserInteractionEnabled = false
        self.numberTextField.isUserInteractionEnabled = false
        self.userNameTextField.isUserInteractionEnabled = false

        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                self.id = userInfoModel.id ?? ""

                self.nameLabel.text = userInfoModel.username
                self.aboutLabel.text = userInfoModel.about
                self.emailTextField.text = userInfoModel.email
                self.numberTextField.text = userInfoModel.mobilenumber
                self.userNameTextField.text = userInfoModel.username
                
                if let imageUrl = userInfoModel.profilePic {
                    self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "userPlaceholder"))
                }

            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }

    }
    
    func isValidateAllFields() -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
//        if self.emailTextField.text?.trimWhiteSpace == "" {
//            errorMsg = "Please enter email"
//            self.emailTextField.becomeFirstResponder()
//        }
//        else if !(self.emailTextField.text?.trimWhiteSpace.isValidEmail)! {
//            errorMsg = "Please enter valid email"
//            self.emailTextField.becomeFirstResponder()
//        }
        
        if self.numberTextField.text?.trimWhiteSpace == "" {
            errorMsg = "Please enter mobile number"
            self.numberTextField.becomeFirstResponder()
        }
        else if !(self.numberTextField.text?.trimWhiteSpace.isValidMobileNumber)! {
            errorMsg = "Please enter valid mobile number"
            self.numberTextField.becomeFirstResponder()
        }
        else if self.userNameTextField.text?.trimWhiteSpace == "" {
            errorMsg = "Please enter username"
            self.userNameTextField.becomeFirstResponder()
        }
        else if !(self.userNameTextField.text?.trimWhiteSpace.isValidUserName)! {
            errorMsg = "Please use only letters upper and lower case, numbers, underscore and periods."
            self.userNameTextField.becomeFirstResponder()
        }
        else {
            isValidate = true
        }
        return (isValidate, errorMsg)
    }

    func profileImagePickerSheet() {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Camera access is denied",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })
        
        present(alertController, animated: true)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alertWarning:UIAlertController=UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alertWarning.addAction(defaultAction)
            
            present(alertWarning, animated: true)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Camera permission
    func checkForAuthorizationStatus() {
        print("auth me")
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
            granted in
            if granted {
                print("granted: \(granted)")
                self.deviceAuthorized = true
                print("raw value: \(AVCaptureDevice.authorizationStatus(for: .video).rawValue)")
            } else {
                self.deviceAuthorized = false
            }
            
        })
    }
        
    // MARK: - Webservice methods
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
                            self.callGetSizePreferenceApi(page: 1)
                            self.setupUIMethod()
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
    
    func callUpdateProfileApi(username: String, mobileNumber: String, about: String) {
        
        let url = BaseUrl + kUpdateProfileApi + self.id
        let parameters: [String: Any] = ["profilePic": "", "username": username, "mobilenumber": mobileNumber, "about": about]

        APIService.sharedInstance.putDataOnServerByAccessToken(url: url, params: parameters, view: self.view, callback: { success, response, responseJson, errorMsg  in
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
                                UserDefaults.standard.synchronize()
                            } catch {
                                print("Unable to Encode Note (\(error))")
                            }

                            self.setupUIMethod()

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

    func callUpdateProfileWithImageApi(profilePic: UIImage, username: String, mobileNumber: String, about: String) {
        
        let url = BaseUrl + kUpdateProfileApi + self.id
        let parameters: [String: String] = ["username": username, "mobilenumber": mobileNumber, "about": about]

        APIService.sharedInstance.putDataOnServerByAccessTokenInFormData(url: url, params: parameters, image: profilePic, imageKey: "profile", view: self.view) { success, response, responseJson, errorMsg  in
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
                                UserDefaults.standard.synchronize()
                            } catch {
                                print("Unable to Encode Note (\(error))")
                            }

                            self.setupUIMethod()

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
        
        let url = BaseUrl + kSizePreferenceApi + "?page=\(page)&size=\(4)"
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(PrefferedSizeModel.self, from: data)
                        UserDefaults.standard.set(data, forKey: "UserPrefferedSizeModel")
                        if modelObj.success == true {
                            self.prefferdSizeList = modelObj.data ?? []
                            if self.prefferdSizeList.count > 0 {
                                self.noDataMessage = ""
                            }else {
                                self.noDataMessage = "No preferred sizes available"
                            }
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

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate methods
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!

        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
        }
        self.profileImageView.image = image
        self.profilePic = image
        self.profileImageButton.setImage(nil, for: .normal)
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = hexStringToUIColor(hex: "#76CEA1", a: 1.0)
        
        picker.dismiss(animated: true)
    }
    
}

// MARK: - UITextFieldDelegate methods
extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
//            let validated = self.isValidateAllFields()
//            if validated.isValidate {
//                self.callUpdateProfileApi(profilePic: "", username: self.userNameTextField.text?.trimWhiteSpace ?? "", mobileNumber: self.numberTextField.text?.trimWhiteSpace ?? "", about: self.aboutTextView.text)
//            }else {
//                self.showAlert(withTitle: "Error!", withMessage: validated.errorMsg)
//            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        var str:NSString = textField.text! as NSString
        str = str.replacingCharacters(in: range, with: string) as NSString
        switch textField.tag {
        case 101:
            if str.length > mobileNumberMaxLength {
                return false
            }
            break
        case 102:
            if str.length > usernameMaxLength {
                return false
            }
            break
        default:
            break
        }
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = hexStringToUIColor(hex: "#76CEA1", a: 1.0)

        return true
    }


    
}

// MARK: - UITextViewDelegate methods
extension ProfileViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.saveButton.isEnabled = true
        self.saveButton.backgroundColor = hexStringToUIColor(hex: "#76CEA1", a: 1.0)
        return true
    }
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        var numOfSections: Int = 0
//        if self.prefferdSizeList.count > 0 {
//            numOfSections            = 1
//            sizeCollectionView.backgroundView = nil
//            return numOfSections
//        }
//        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: sizeCollectionView.bounds.size.width, height: sizeCollectionView.bounds.size.height))
//        noDataLabel.text          = self.noDataMessage
//        noDataLabel.font = UIFont.init(name: "Poppins-Regular", size: 15.0)
//        noDataLabel.textColor     = UIColor.white
//        noDataLabel.textAlignment = .center
//        sizeCollectionView.backgroundView  = noDataLabel
//        return numOfSections
//
//    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.prefferdSizeList.count > 3 {
            return 4
        }
        return self.prefferdSizeList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCollectionViewCell", for: indexPath) as! ItemsCollectionViewCell

        if indexPath.item == 3 {
            cell.moreView.isHidden = false
            cell.itemImageView.isHidden = true
            cell.itemNameLabel.isHidden = true
            cell.itemUSLabel.isHidden = true
            cell.itemUKLabel.isHidden = true
        }else {
            let item = self.prefferdSizeList[indexPath.item]
            
            cell.moreView.isHidden = true
            cell.itemImageView.isHidden = false
            cell.itemNameLabel.isHidden = false
            cell.itemUSLabel.isHidden = false
            cell.itemUKLabel.isHidden = false
            cell.itemUSLabel.text = "US: --"
            cell.itemUKLabel.text = "UK: --"

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

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/4 - 8, height: (collectionView.frame.width/4 - 8) + 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MoreSizesViewController") as! MoreSizesViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
}

class ItemsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemUSLabel: UILabel!
    @IBOutlet weak var itemUKLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var moreView: UIView!
}
