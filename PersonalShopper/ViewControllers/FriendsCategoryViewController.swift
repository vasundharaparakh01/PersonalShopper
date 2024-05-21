//
//  FriendsCategoryViewController.swift
//  appName
//
//  Created by iOS Dev on 10/08/22.
//

import UIKit
import SDWebImage

class FriendsCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!

    var subCategoryArray = [SubCategoryDataModel]()
    var searchSubCategoryArray = [SubCategoryDataModel]()

    var categoryArray = [CategoryDataModel]()
    var selectedIndex = 0
    var catId = ""
    var friendId = ""
    

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func categorySegmentAction(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        if self.selectedIndex == 0 {
            if let catid = UserDefaults.standard.value(forKey: "MEN") as? String {
                self.catId = catid
            }
        }else {
            if let catid = UserDefaults.standard.value(forKey: "WOMEN") as? String {
                self.catId = catid
            }
        }
        self.callGetSubCategoryByCatIdApi(id: self.catId)

    }

    @IBAction func sizingButtonAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "SizingViewController") as! SizingViewController
        vc.categoryArray = self.categoryArray
        vc.selectedIndex = self.selectedIndex
        vc.isFromHome = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

}

//MARK: Helper methods
extension FriendsCategoryViewController {
    
    func initialSetup() {
        if let catid = UserDefaults.standard.value(forKey: "MEN") as? String {
            self.catId = catid
        }
//        self.searchSubCategoryArray = self.subCategoryArray
//        self.categoryCollectionView.reloadData()
        self.callGetSubCategoryByCatIdApi(id: self.catId)
    }
    
    func searchSubCategoryByName(text: String) {
        print("Search:=====",text)
        let filtered = self.subCategoryArray.filter { $0.name!.localizedCaseInsensitiveContains(text) }

        self.searchSubCategoryArray = filtered

        if text == "" {
            self.searchSubCategoryArray = self.subCategoryArray
        }
        
        self.categoryCollectionView.reloadData()
    }
    
    // MARK: - Webservice methods
    func callGetSubCategoryByCatIdApi(id: String) {
        
        let url = BaseUrl + kGetSubCategoryByCatIdApi + id
        
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


}

// MARK: - UITextFieldDelegate methods
extension FriendsCategoryViewController: UITextFieldDelegate {
    
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

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource methods
extension FriendsCategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchSubCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCollectionViewCell", for: indexPath) as! AllCategoryCollectionViewCell
        
        let obj = self.searchSubCategoryArray[indexPath.item]
        if let imageUrl = obj.image {
            cell.itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.itemImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        cell.itemNameLabel.text = obj.name

        cell.itemImageView.isHidden = false
        cell.itemNameLabel.isHidden = false

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/4 - 15, height: collectionView.frame.width/4 + 15)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "EditItemViewController") as! EditItemViewController
        vc.subCategoryData = self.searchSubCategoryArray[indexPath.item]
        vc.isFriend = true
        vc.friendId = self.friendId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}
