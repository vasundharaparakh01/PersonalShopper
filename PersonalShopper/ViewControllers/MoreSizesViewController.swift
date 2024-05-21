//
//  MoreSizesViewController.swift
//  appName
//
//  Created by iOS Dev on 31/08/22.
//

import UIKit
import SDWebImage

class MoreSizesViewController: UIViewController {
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!

    var prefferdSizeList = [PrefferedSizeModelData]()

    var page: Int = 1
    var isPageRefreshing:Bool = false
    var noDataMessage = ""
    var friendId = ""
    

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    // MARK: - UIButtonActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - Helper methods
extension MoreSizesViewController {
    
    func initialSetup() {
        self.callGetSizePreferenceApi(page: self.page)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.sizeCollectionView.contentOffset.y >= (self.sizeCollectionView.contentSize.height - self.sizeCollectionView.bounds.size.height)) {
            if !isPageRefreshing {
                isPageRefreshing = true
                print(page)
                page = page + 1
                self.callGetSizePreferenceApi(page: self.page)
            }
        }
    }

    // MARK: - Webservice methods
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
                            if self.prefferdSizeList.count > 0 {
                                self.noDataMessage = ""
                            }else {
                                self.noDataMessage = "No data available"
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout methods
extension MoreSizesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if self.prefferdSizeList.count > 0 {
            numOfSections            = 1
            sizeCollectionView.backgroundView = nil
            return numOfSections
        }
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: sizeCollectionView.bounds.size.width, height: sizeCollectionView.bounds.size.height))
        noDataLabel.text          = self.noDataMessage
        noDataLabel.font = UIFont.init(name: "Poppins-Regular", size: 15.0)
        noDataLabel.textColor     = UIColor.white
        noDataLabel.textAlignment = .center
        sizeCollectionView.backgroundView  = noDataLabel
        return numOfSections

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prefferdSizeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/4 - 8, height: (collectionView.frame.width/4 - 8) + 34)
    }
    
}
