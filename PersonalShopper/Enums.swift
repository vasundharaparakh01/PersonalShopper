//
//  Enums.swift
//  MYFAVS
//
//  Created by iOS Dev on 09/06/22.
//

import UIKit

enum Keys {
    static let resultFile = "resultFile"
    static let email = "email"
    static let password = "password"
    static let firstname = "firstname"
    static let lastname = "lastname"
    static let access_token = "access_token"
    static let profilePic = "profilePic"
    static let allowStore = "allowStore"
}

enum ScreenType {
    static let home = "Home"
    static let profile = "Profile"
    static let settings = "Settings"
    static let notifications = "Notifications"
    static let terms = "Terms"
    static let changePassword = "ChangePassword"
    static let favourite = "Favourite"
    static let addMember = "AddMember"
    static let pendingRequest = "PendingRequest"
}

enum TabItem: String, CaseIterable {
    case home = "home"
    case favourite = "favourite"
    case addMember = "addMember"
    case profile = "profile"
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .favourite:
            return MyFavsViewController()
        case .addMember:
            return HomeViewController()
        case .profile:
            return ProfileViewController()
        }
    }
    
    // these can be your icons
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "btmHome")!
        case .favourite:
            return UIImage(named: "heart")!
        case .addMember:
            return UIImage(named: "addGroup")!
        case .profile:
            return UIImage(named: "btmProfile")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
    
}
