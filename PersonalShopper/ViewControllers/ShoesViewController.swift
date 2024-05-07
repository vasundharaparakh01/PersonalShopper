//
//  ShoesViewController.swift
//  MYFAVS
//
//  Created by iOS Dev on 17/06/22.
//

import UIKit

class ShoesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    // MARK: - View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.initialSetup()
    }

    // MARK: - UIButtonActions
    @IBAction func sliderValueChangedAction(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        print("Slider changing to \(currentValue) ?")
        
        DispatchQueue.main.async {
            self.sliderLabel.text = "\(currentValue)"
            self.sliderLabel.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                self.sliderLabel.isHidden = true
            }
        }
        
    }
        
    @IBAction func homeButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let vc = TabBarVCShared.shared.HomeVC
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func heartButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "MyFavsViewController") as! MyFavsViewController
        let vc = TabBarVCShared.shared.MyFavsVC
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
 
    }

    @IBAction func addButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = TabBarVCShared.shared.MyFriendsVC
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = TabBarVCShared.shared.MyProfileVC
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }

}

// MARK: - Helper methods
extension ShoesViewController {
    
    func initialSetup() {
        self.sliderLabel.isHidden = true
    }
        
}
