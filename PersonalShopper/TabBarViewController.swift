//
//  TabBarViewController.swift
//  appName
//
//  Created by iOS Dev on 13/06/22.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func TabBar(){
        tabBarView.layer.cornerRadius = tabBarView.frame.size.height/2
        tabBarView.clipsToBounds = true
    }
    
    @IBAction func commonButtonAction(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        
        if tag == 1000{
            guard let homeVC = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else { return}
            contentView.addSubview(homeVC.view)
            homeVC.didMove(toParent: self)
           
            
        }else if tag == 1001{
            guard let favouriteVC = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return}
            contentView.addSubview(favouriteVC.view)
            favouriteVC.didMove(toParent: self)
            
        }else if tag == 1002{
            guard let addMemberVC = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else { return}
            contentView.addSubview(addMemberVC.view)
            addMemberVC.didMove(toParent: self)
            
        }else{
           
            guard let profileVC = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController else { return}
            contentView.addSubview(profileVC.view)
            profileVC.didMove(toParent: self)
        }
    }
    

}
