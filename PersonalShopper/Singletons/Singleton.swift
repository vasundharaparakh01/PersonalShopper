//
//  Singleton.swift
//  FIFA
//
//  Created by iOS Dev on 10/01/22.
//

import UIKit
import MBProgressHUD

class SharedClass: NSObject {//This is shared class
static let sharedInstance = SharedClass()
    
//    var contacts = [Dictionary<String, Any>]()
    
    var contacts: [Dictionary<String, Any>] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "userContacts") else { return [] }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Dictionary<String, Any>] ?? []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            UserDefaults.standard.set(data, forKey: "userContacts")
        }
    }


    //Show alert
//    func alert(view: UIViewController, title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
//        })
//        alert.addAction(defaultAction)
//        DispatchQueue.main.async(execute: {
//            view.present(alert, animated: true)
//        })
//    }
    
    func alertWindow(title: String, message: String) {
        DispatchQueue.main.async(execute: {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }

            let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction2 = UIAlertAction(title: "OK", style: .default, handler: { action in
            })
            alert2.addAction(defaultAction2)
        
            window.makeKeyAndVisible()
            window.rootViewController?.present(alert2, animated: true, completion: nil)
        })
    }
    
    func gotoLogin(view: UIView) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = ""
        hud.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false

        // Reset User Defaults
        UserDefaults.standard.reset()
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            MBProgressHUD.hide(for: view, animated: true)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            UIApplication.shared.windows.first?.rootViewController = navController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }


    private override init() {
    }
    
}


class Token {

    // Can't init a singleton
    private init() { }

    static let sharedInstance = Token()

    var tokenString = ""

}


class TabBarVCShared {
    
    private init(){}
    
    static let shared = TabBarVCShared()
    
    lazy var HomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    
    lazy var appNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "appNameViewController") as! appNameViewController
    
    lazy var MyFriendsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
    
    lazy var MyProfileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    
}
