//
//  FavsDetailsViewController.swift
//  appName
//
//  Created by iOS Dev on 13/07/22.
//

import UIKit
import SDWebImage

class FavsDetailsViewController: UIViewController {

    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var subSubategoryLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sizeTypeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    var favsModel: GetAllProductModelDataItems?
    var timer = Timer()
    var pageIndex : Int = 0

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
extension FavsDetailsViewController {
    
    func initialSetup() {
        self.nameLabel.text = favsModel?.name ?? ""
        self.categoryLabel.text = favsModel?.categories?.name ?? ""
        self.subCategoryLabel.text = favsModel?.subcategories?.name ?? ""
        if favsModel?.subsubcategories?.count ?? 0 > 0 {
            self.subSubategoryLabel.text = favsModel?.subsubcategories?[0].name ?? ""
        }
        self.locationLabel.text = favsModel?.location ?? ""
        self.sizeLabel.text = favsModel?.size ?? ""
        self.sizeTypeLabel.text = favsModel?.sizeType ?? ""

        self.intiateBannerView()
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        self.linkLabel.textColor = UIColor.lightText
        self.linkLabel.attributedText = NSAttributedString(string: favsModel?.productlink ?? "", attributes: underlineAttribute)
//        let underlineAttributedString = NSAttributedString(string: "StringWithUnderLine", attributes: underlineAttribute)
//        myLabel.attributedText = underlineAttributedString

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        self.linkLabel.addGestureRecognizer(tapGesture)
        self.linkLabel.isUserInteractionEnabled = true

//        self.linkLabel.text = favsModel?.productlink ?? ""

    }
    
    @objc func labelTapped(gesture: UITapGestureRecognizer) {
        
        if gesture.didTapAttributedString((favsModel?.productlink)!, in: self.linkLabel) {
            
            print("\(favsModel?.productlink ?? "") tapped")
            
            guard let url = URL(string: favsModel?.productlink ?? "") else {
                self.showAlert(withTitle: appName, withMessage: "Invalid url")
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

        }else {
            print("Text tapped")
        }
    }
    
    func intiateBannerView() {
        
        pageController.numberOfPages = favsModel?.images?.count ?? 0
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
        if favsModel?.images?.count ?? 0 > 0 {
            if let imageUrl = favsModel?.images?[0].url as? String {
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
                
                self.pageIndex = (pageIndex != 0) ? self.pageIndex - 1 : (favsModel?.images?.count ?? 0) - 1
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
                
                self.pageIndex = (pageIndex != (favsModel?.images?.count ?? 0)-1) ? self.pageIndex + 1 : 0
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
            
            if let imageUrl = favsModel?.images?[pageIndex].url as? String {
                self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
            }

        }
        self.startTimer()
    }
    
    @objc func loadNextImage() {
        
        self.pageIndex = (pageIndex != (favsModel?.images?.count ?? 0)-1) ? self.pageIndex + 1 : 0
//        self.pageIndex = (pageIndex != self.arrPageImage.count-1) ? self.pageIndex + 1 : 0
        self.pageController.currentPage = self.pageIndex
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.bannerView.layer.add(transition, forKey:"SwitchToView")
        
        if let imageUrl = favsModel?.images?[pageIndex].url as? String {
            self.bannerView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.bannerView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "placeholder"))
        }
        
    }

    
}
