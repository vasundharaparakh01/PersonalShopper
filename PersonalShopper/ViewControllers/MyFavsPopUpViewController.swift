//
//  appNamePopUpViewController.swift
//  appName
//
//  Created by iOS Dev on 15/06/22.
//

import UIKit
import AVFoundation
import SDWebImage

protocol appNamePopUpViewDelegate {
    func dismissappNamePopUp()
}

class appNamePopUpViewController: UIViewController {

    var delegate: appNamePopUpViewDelegate?
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var onlineSeperatorLabel: UILabel!
    @IBOutlet weak var onLocationSeperatorLabel: UILabel!

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var subCategoryButton: UIButton!
    @IBOutlet weak var subSubCategoryButton: UIButton!
    @IBOutlet weak var sizeTypeButton: UIButton!
    @IBOutlet weak var sizeButton: UIButton!
    @IBOutlet weak var onlineButton: UIButton!
    @IBOutlet weak var onLocationButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var linkUrlTextfield: UITextField!
    @IBOutlet weak var locationTextfield: UITextField!
//    @IBOutlet weak var sizeTypeTextfield: UITextField!
    @IBOutlet weak var sizeTextfield: UITextField!

    var categoryArray = [CategoryDataModel]()
    var subCategoryArray = [SubCategoryDataModel]()
    var subSubCategoryArray = [SubSubCategoryDataModel]()
    var sizeFormats = [SizeFormats]()

    var sizesArray = [String]()
    var sizesTypeArray = [String]()

    var imagesArray = [UIImage]()
    var imagesUrlArray = [String]()
    var isOnline = true
    var deviceAuthorized = Bool()
    var imagePicker = UIImagePickerController()
    var catId = ""
    var subcatId = ""
    var subSubcatId = ""
    var sizeFormatId = ""

    var sizeTypeValue = ""
    var sizeValue = ""

    var isEdit = false
    var isImageUpdate = false

    var isFirstCat = true
    var isFirstSubCat = true
    var isFirstSubSubCat = true
    var isFirstSizeType = true

    var favsModel: GetAllProductModelDataItems?
//    var sizeArray = [String]()

    let categoryDrop = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDrop
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func onLineOffLineButtonAction(_ sender: UIButton) {
        if sender.tag == 100 {
            self.isOnline = true
            self.locationView.isHidden = true
            self.linkView.isHidden = false
            self.onlineSeperatorLabel.backgroundColor = UIColor.init(hex: "FC2E34")
            self.onLocationSeperatorLabel.backgroundColor = .white
        }else{
            self.isOnline = false
            self.locationView.isHidden = false
            self.linkView.isHidden = true
            self.onlineSeperatorLabel.backgroundColor = .white
            self.onLocationSeperatorLabel.backgroundColor = UIColor.init(hex: "FC2E34")
        }
    }
    
    @IBAction func plusButtonAction(_ sender: UIButton) {
        if self.imagesArray.count < 3 {
            //        if self.deviceAuthorized {
                        self.imagePickerSheet()
            //        }else {
            //            self.presentCameraSettings()
            //        }
        }else {
            AlertController.alert(title: appName, message: "You can choose maximum 3 images")
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @objc func deleteButtonAction(_ sender: UIButton) {
        if self.isImageUpdate {
            self.imagesArray.remove(at: sender.tag)
        }else {
            self.imagesArray.removeAll()
            self.imagesUrlArray.remove(at: sender.tag)
        }
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        let validated = self.isValidateAllFields()
        if validated.isValidate {
            if self.isEdit {
                self.callEditProductWithImageApi(productPics: self.imagesArray, descriptionStr: "", catId: self.catId, subCatId: self.subcatId, subSubCatId: self.subSubcatId, size: self.sizeValue, name: self.nameTextfield.text?.trimWhiteSpace ?? "", isOnline: self.isOnline, location: self.locationTextfield.text?.trimWhiteSpace ?? "", productlink: self.linkUrlTextfield.text?.trimWhiteSpace ?? "", sizeType: self.sizeTypeValue)
            }else {
                self.callCreateProductWithImageApi(productPics: self.imagesArray, descriptionStr: "", catId: self.catId, subCatId: self.subcatId, subSubCatId: self.subSubcatId, size: self.sizeValue, name: self.nameTextfield.text?.trimWhiteSpace ?? "", isOnline: self.isOnline, location: self.locationTextfield.text?.trimWhiteSpace ?? "", productlink: self.linkUrlTextfield.text?.trimWhiteSpace ?? "", sizeType: self.sizeTypeValue)
            }
        }else {
            self.showAlert(withTitle: appName, withMessage: validated.errorMsg)
        }

    }
    
    @IBAction func dropDownButtonAction(_ sender: UIButton) {
        self.view .endEditing(true)
        
        let validated = self.isValidateAllDropdown(index: sender.tag - 100)
        if !validated.isValidate {
            self.showAlert(withTitle: appName, withMessage: validated.errorMsg)
            return
        }

        self.categoryDrop.anchorView = sender
        self.categoryDrop.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        self.categoryDrop.dataSource.removeAll()
        if sender.tag == 100 {
            if self.categoryArray.count == 0 {
                self.showAlert(withTitle: appName, withMessage: "No category")
            }
            self.categoryDrop.dataSource = self.categoryArray.map({ $0.name ?? "" })
        }else if sender.tag == 101 {
            if self.subCategoryArray.count == 0 {
                self.showAlert(withTitle: appName, withMessage: "No sub category")
            }
            self.categoryDrop.dataSource = self.subCategoryArray.map({ $0.name ?? "" })
        }else if sender.tag == 102 {
            if self.subSubCategoryArray.count == 0 {
                self.showAlert(withTitle: appName, withMessage: "No sub sub category")
            }
            self.categoryDrop.dataSource = self.subSubCategoryArray.map({ $0.name ?? "" })
        }else if sender.tag == 103 {
            if self.sizesTypeArray.count == 0 {
                self.showAlert(withTitle: appName, withMessage: "No size type")
            }
            self.categoryDrop.dataSource = self.sizesTypeArray
        }else {
            if self.sizesArray.count == 0 {
                self.showAlert(withTitle: appName, withMessage: "No sizes")
            }
            self.categoryDrop.dataSource = self.sizesArray
        }
        
        // Action triggered on selection
        self.categoryDrop.selectionAction = { [unowned self] (index, item) in
            
            sender.setTitle("  " + item, for: .normal)
            print("\(index)")
            
            if sender.tag == 100 {
                let obj = self.categoryArray[index]
                self.catId = obj.id ?? ""
                self.callGetSubCategoryByCatIdApi(id: obj.id ?? "")
            }else if sender.tag == 101 {
                let obj = self.subCategoryArray[index]
                self.subcatId = obj.id ?? ""
                
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

                self.callGetSubSubCategoryByCatIdApi(id: obj.id ?? "", userId: userId)
            }else if sender.tag == 102 {
                let obj = self.subSubCategoryArray[index]
                if let sizeFormats = obj.subCatId?.sizeFormats {
                    self.sizeFormats = sizeFormats
                    self.sizesTypeArray = sizeFormats.map({ $0.sizeType ?? "" })
                }
                self.subSubcatId = obj.id ?? ""
                self.sizeTypeButton.setTitle("Select size type", for: .normal)
                self.sizeButton.setTitle("Select size", for: .normal)
            }else if sender.tag == 103 {
                let obj = self.sizeFormats[index]
                if let sizeType = obj.sizeType {
                    self.sizeTypeValue = sizeType
                }
                if let sizes = obj.sizes {
                    self.sizesArray = sizes
                }
                self.sizeFormatId = obj.id ?? ""
                self.sizeButton.setTitle("Select size", for: .normal)
//                self.callGetSizesApi(id: self.subSubcatId, sizeType: self.sizeTypeValue)
            }else {
                self.sizeValue = self.sizesArray[index]
            }

        }
        self.categoryDrop.show()
    }

}

// MARK: - Helper methods
extension appNamePopUpViewController {
    
    func initialSetup() {
        //        self.sizeArray = ["S","M","L","XL","XXL"]
//        self.sizesTypeArray = ["US","UK"]
        self.onlineSeperatorLabel.backgroundColor = UIColor.init(hex: "FC2E34")

        self.submitButton.roundCorners(corners: [.topLeft, .bottomLeft], radius: 15)
        self.rightArrowButton.roundCorners(corners: [.topRight, .bottomRight], radius: 15)
//        self.bgImageView.transform = self.bgImageView.transform.rotated(by: CGFloat(Double.pi))
                
        if self.isEdit {
            if let images = self.favsModel?.images {
                self.imagesArray = []
//                for item in images {
//                    let imageView = UIImageView()
//                    if let imageUrl = item.url {
//                        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, imageURL) in
//                            self.imagesArray.append(image!)
//                        })
//                    }
//                }
                
                for item in images {
                    if let imageUrl = item.url {
                        self.imagesUrlArray.append(imageUrl)
                    }
                }
                self.imageCollectionView.reloadData()

            }
            if let name = self.favsModel?.name {
                self.nameTextfield.text = name
            }
            if let productlink = self.favsModel?.productlink {
                self.linkUrlTextfield.text = productlink
            }
            if let location = self.favsModel?.location {
                self.locationTextfield.text = location
            }
            if let sizeType = self.favsModel?.sizeType {
                self.sizeTypeValue = sizeType
                self.sizeTypeButton.setTitle(self.sizeTypeValue, for: .normal)
            }
            if let size = self.favsModel?.size {
                self.sizeTextfield.text = size
                self.sizeValue = size
                self.sizeButton.setTitle(self.sizeValue, for: .normal)
            }
            if let name = self.favsModel?.categories?.name {
                self.categoryButton.setTitle(name, for: .normal)
            }
            if let name = self.favsModel?.subcategories?.name {
                self.subCategoryButton.setTitle(name, for: .normal)
            }
            if let name = self.favsModel?.subsubcategories?[0].name {
                self.subSubCategoryButton.setTitle(name, for: .normal)
            }

            if let isOnline = self.favsModel?.isOnline, isOnline {
                self.isOnline = true
                self.onlineSeperatorLabel.backgroundColor = UIColor.init(hex: "FC2E34")
                self.onLocationSeperatorLabel.backgroundColor = .white
                self.locationView.isHidden = true
                self.linkView.isHidden = false
            }else {
                self.isOnline = false
                self.onlineSeperatorLabel.backgroundColor = .white
                self.onLocationSeperatorLabel.backgroundColor = UIColor.init(hex: "FC2E34")
                self.locationView.isHidden = false
                self.linkView.isHidden = true
            }
            
            if let catId = self.favsModel?.catId {
                self.catId = catId
            }
            if let subCatId = self.favsModel?.subCatId {
                self.subcatId = subCatId
            }
            if let subSubCatId = self.favsModel?.subSubCatId {
                self.subSubcatId = subSubCatId
            }

            self.callGetCategoryApi()
        }else {
            self.locationView.isHidden = true
            self.linkView.isHidden = false
            self.callGetCategoryApi()
        }

    }
    
    func isValidateAllFields() -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
        if self.imagesArray.count == 0 {
            errorMsg = "Please select image"
        }
        else if self.nameTextfield.text?.trimWhiteSpace == "" {
            errorMsg = "Please enter name"
            self.nameTextfield.becomeFirstResponder()
        }else if self.catId == "" {
            errorMsg = "Please select category"
        }
        else if self.subcatId == "" {
            errorMsg = "Please select sub category"
        }
        else if self.subSubcatId == "" {
            errorMsg = "Please select sub sub category"
        }
        //        if self.linkUrlTextfield.text?.trimWhiteSpace == "" {
        //            errorMsg = "Please enter link"
        //            self.linkUrlTextfield.becomeFirstResponder()
        //        }
//        if self.locationTextfield.text?.trimWhiteSpace == "" {
//            errorMsg = "Please enter location"
//            self.locationTextfield.becomeFirstResponder()
//        }
        else if self.linkUrlTextfield.text?.trimWhiteSpace != "" && !(self.linkUrlTextfield.text?.trimWhiteSpace.isValidURL)! {
            errorMsg = "Please enter valid link"
        }
        else if self.sizeValue == "" {
            errorMsg = "Please select size"
//            self.sizeTextfield.becomeFirstResponder()
        }
        else {
            isValidate = true
        }
        
        return (isValidate, errorMsg)
    }

    func isValidateAllDropdown(index: Int) -> (isValidate : Bool, errorMsg : String) {
        var errorMsg = ""
        var isValidate = false
        
        if index == 1{
            if self.catId == "" {
                errorMsg = "Please select category"
            }else {
                isValidate = true
            }
        }else if index == 2{
            if self.catId == "" {
                errorMsg = "Please select category"
            }else if self.subcatId == "" {
                errorMsg = "Please select sub category"
            }else {
                isValidate = true
            }
        }else if index == 3{
            if self.catId == "" {
                errorMsg = "Please select category"
            }else if self.subcatId == "" {
                errorMsg = "Please select sub category"
            }
            else if self.subSubcatId == "" {
                errorMsg = "Please select sub sub category"
            }else {
                isValidate = true
            }
        }else if index == 4{
            if self.catId == "" {
                errorMsg = "Please select category"
            }else if self.subcatId == "" {
                errorMsg = "Please select sub category"
            }
            else if self.subSubcatId == "" {
                errorMsg = "Please select sub sub category"
            }else if self.sizeTypeValue == "" {
                errorMsg = "Please select size type"
            }else {
                isValidate = true
            }
        }
        else {
            isValidate = true
        }
        
        return (isValidate, errorMsg)
    }

    func imagePickerSheet() {
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
                            self.subCategoryArray = []
                            self.subSubCategoryArray = []
                            self.sizesArray = []

                            if self.isEdit && self.isFirstCat {
                                self.isFirstCat = false
                                self.callGetSubCategoryByCatIdApi(id: self.favsModel?.catId ?? "")
                            }else {
                                self.catId = ""
                                self.subcatId = ""
                                self.subSubcatId = ""
                                self.subCategoryButton.setTitle("Select sub category", for: .normal)
                                self.subSubCategoryButton.setTitle("Select sub sub category", for: .normal)
                                self.sizeTypeButton.setTitle("Select size type", for: .normal)
                                self.sizeButton.setTitle("Select size", for: .normal)
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
    
    func callGetSubCategoryByCatIdApi(id: String) {

        let url = BaseUrl + kGetSubCategoryByCatIdApi + id

        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SubCategoryModel.self, from: data)
                        if modelObj.success == true {
                            self.subCategoryArray = modelObj.data ?? []
                            self.subSubCategoryArray = []
                            self.sizesArray = []

                            if self.isEdit && self.isFirstSubCat {
                                self.isFirstSubCat = false
                                
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

                                self.callGetSubSubCategoryByCatIdApi(id: self.favsModel?.subCatId ?? "", userId: userId)
                            }else {
                                self.subcatId = ""
                                self.subSubcatId = ""
                                self.subCategoryButton.setTitle("Select sub category", for: .normal)
                                self.subSubCategoryButton.setTitle("Select sub sub category", for: .normal)
                                self.sizeTypeButton.setTitle("Select size type", for: .normal)
                                self.sizeButton.setTitle("Select size", for: .normal)
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

    func callGetSubSubCategoryByCatIdApi(id: String, userId: String) {
        
//        let url = BaseUrl + kGetSubSubCategoryBySubCatIdApi + id
        let url = BaseUrl + kGetSubSubCategoryBySubCatIdApi + "\(id)" + "?userId=\(userId)"
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SubSubCategoryModel.self, from: data)
                        if modelObj.success == true {
                            self.subSubCategoryArray = modelObj.data ?? []
                            self.sizeFormats = []
                            self.sizesArray = []
                            self.sizesTypeArray = []

                            if self.isEdit && self.isFirstSubSubCat {
                                self.isFirstSubSubCat = false
                                
                                let subSubCatList = self.subSubCategoryArray.filter{ ($0.id?.contains(self.subSubcatId))! }
                                let obj = subSubCatList[0]
                                if let sizeFormats = obj.subCatId?.sizeFormats {
                                    self.sizeFormats = sizeFormats
                                    self.sizesTypeArray = sizeFormats.map({ $0.sizeType ?? "" })
                                }
                                let sizeFormat = self.sizeFormats.filter{ ($0.sizeType?.contains(self.sizeTypeValue))! }
                                let sizeFormatObj = sizeFormat[0]
                                if let sizeType = sizeFormatObj.sizeType {
                                    self.sizeTypeValue = sizeType
                                }
                                if let sizes = sizeFormatObj.sizes {
                                    self.sizesArray = sizes
                                }
//                                self.callGetSizesApi(id: self.subSubcatId, sizeType: self.sizeTypeValue)
                            }else {
                                self.subSubcatId = ""
                                self.subSubCategoryButton.setTitle("Select sub sub category", for: .normal)
                                self.sizeTypeButton.setTitle("Select size type", for: .normal)
                                self.sizeButton.setTitle("Select size", for: .normal)
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
    
    func callGetSizesApi(id: String, sizeType: String) {
        
        let url = BaseUrl + kGetSizesBySubSubCatIdApi + id + "/\(sizeType)"

        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(SizesModel.self, from: data)
                        if modelObj.success == true {
                            if modelObj.data?.count ?? 0 > 0 {
                                self.sizesArray = modelObj.data?[0].sizes ?? []
                            }
                            if self.isEdit && self.isFirstSizeType {
                                self.isFirstSizeType = false
                            }else {
                                self.sizeButton.setTitle("Select size", for: .normal)
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

    func callCreateProductWithImageApi(productPics: [UIImage], descriptionStr: String, catId: String, subCatId: String, subSubCatId: String, size: String, name: String, isOnline: Bool, location: String, productlink: String, sizeType: String) {
        
        let url = BaseUrl + kCreateProductApi
        let parameters: [String: Any] = ["description": descriptionStr, "catId": catId, "subCatId": subCatId, "subSubCatId": subSubCatId, "size": size, "name": name, "IsOnline": isOnline, "location": location, "productlink": productlink, "sizeType": sizeType]

        APIService.sharedInstance.postDataOnServerByAccessTokenInFormData(url: url, params: parameters, images: productPics, imageKey: "images", isAuth: true, view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(ProductModel.self, from: data)
                        if modelObj.success == true {
                            print(modelObj)
                            AlertController.alert(title: appName, message: modelObj.message ?? "", buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                self.dismiss(animated: true) {
                                    if (self.delegate != nil) {
                                        self.delegate?.dismissappNamePopUp()
                                    }
                                }
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
    
    func callEditProductWithImageApi(productPics: [UIImage], descriptionStr: String, catId: String, subCatId: String, subSubCatId: String, size: String, name: String, isOnline: Bool, location: String, productlink: String, sizeType: String) {
        
        let url = BaseUrl + kUpdateProductApi + (self.favsModel?.id ?? "")
        let parameters: [String: Any] = ["description": descriptionStr, "catId": catId, "subCatId": subCatId, "subSubCatId": subSubCatId, "size": size, "name": name, "IsOnline": isOnline, "location": location, "productlink": productlink, "sizeType": sizeType]

        APIService.sharedInstance.putDataOnServerByAccessTokenInFormDataWithMultipleImages(url: url, params: parameters, images: productPics, imageKey: "images", view: self.view) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(ProductModel.self, from: data)
                        if modelObj.success == true {
                            print(modelObj)
                            AlertController.alert(title: appName, message: modelObj.message ?? "", buttons: ["Ok"]) { UIAlertAction, selectedIndex in
                                self.dismiss(animated: true) {
                                    if (self.delegate != nil) {
                                        self.delegate?.dismissappNamePopUp()
                                    }
                                }
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

    
}

// MARK: - UICollectionViewDelegatem & UICollectionViewDataSource methods
extension appNamePopUpViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isEdit && !self.isImageUpdate {
            return self.imagesUrlArray.count
        }
        return self.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopUpImageCollectionViewCell", for: indexPath) as! PopUpImageCollectionViewCell
        
        if self.isEdit && !self.isImageUpdate {
            cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.itemImageView.sd_setImage(with: URL(string: self.imagesUrlArray[indexPath.item]), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, imageURL) in
                if self.imagesArray.count < self.imagesUrlArray.count {
                    self.imagesArray.append(image!)
                }
            })

        }else {
            cell.itemImageView.image = self.imagesArray[indexPath.item]
        }
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction(_:)), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 83, height: 83)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = 83 * collectionView.numberOfItems(inSection: 0)
//        let totalSpacingWidth = 4 * (collectionView.numberOfItems(inSection: 0) - 1)
//
//        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
        
        // Add your button here

        return view

    }
        
}


// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate methods
extension appNamePopUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
        self.imagesArray.append(image)
        self.isImageUpdate = true

        picker.dismiss(animated: true)
        self.imageCollectionView.reloadData()
    }
    
}


//MARK: - UITextFieldDelegates Methods
extension appNamePopUpViewController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let tf: UITextField? = (view.viewWithTag(textField.tag + 1) as? UITextField)
            tf?.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
        }
        return true
    }

}


//MARK: PopUpImageCollectionViewCell
class PopUpImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

}


