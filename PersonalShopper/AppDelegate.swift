//
//  AppDelegate.swift
//  appName
//
//  Created by Chandani Barsagade on 5/30/22.
//

import UIKit
import FacebookCore
import FBSDKCoreKit
import GoogleSignIn
import SideMenu

import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import Contacts

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
//        //        // Initialize Facebook SDK
//        FBSDKCoreKit.ApplicationDelegate.shared.application(
//            application,
//            didFinishLaunchingWithOptions: launchOptions
//        )
        
//        GIDSignIn.sharedInstance().clientID = "201782800631-0lmf83igrpf2vpeu2k6dc1d5rumn2mca.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            // Show the app's signed-out state.
              print("the app's signed-out state")
          } else {
            // Show the app's signed-in state.
              print("the app's signed-in state")
          }
        }

        
        
        // 1
        FirebaseApp.configure()
        // 2
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        // 1
        UNUserNotificationCenter.current().delegate = self
        // 2
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { _, _ in }
        // 3
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
//        UserDefaults.standard.set(true, forKey: UserDefaults.Keys.IsContacts.rawValue)
//        UserDefaults.standard.synchronize()
        return true
    }
        
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
        
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
          return true
        }

        // Handle other custom URL types.

        // If not handled by this app, return false.
        return false

        
        //        return GIDSignIn.sharedInstance().handle(url)
    }
    
//    func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
//        if let urlString =
//          event?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue{
//            let url = NSURL(string: urlString)
//            GIDSignIn.sharedInstance.handle(url)
//        }
//    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
        
}



// MARK: Push notification
//extension AppDelegate {
//    func registerForPushNotifications() {
//        //1
//        UNUserNotificationCenter.current()
//        //2
//            .requestAuthorization(
//                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
//                    //3
//                    print("Permission granted: \(granted)")
//                    guard granted else { return }
//                    self?.getNotificationSettings()
//                }
//
//    }
//
//    func getNotificationSettings() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//
//}

// MARK: UNUserNotificationCenterDelegate methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound]])
        } else {
            // Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }

        // Print full message.
        print(userInfo)
        
        var notType = ""
        var senderId = ""
        if let type = userInfo["notificationType"] as? String {
            notType = type
        }
        if let id = userInfo["google.c.sender.id"] as? String {
            senderId = id
        }
        self.notificationNavigationSetup(type: notType, senderId: senderId)
        
        completionHandler()
    }
    
    func notificationNavigationSetup(type: String, senderId: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let connectVC = storyboard.instantiateViewController(withIdentifier: "ConnectUserViewController") as! ConnectUserViewController
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate else { return }

        if let isLogin = UserDefaults.standard.value(forKey: UserDefaults.Keys.IsLogin.rawValue) as? Bool, isLogin {
            if type == "1" {
                connectVC.friendId = senderId
                delegate.navController = UINavigationController(rootViewController: connectVC)
            }else if type == "2" {
                homeVC.isFromNoti = true
                delegate.navController = UINavigationController(rootViewController: homeVC)
            }else if type == "3" {
                connectVC.friendId = senderId
                delegate.navController = UINavigationController(rootViewController: connectVC)
            }else {
                delegate.navController = UINavigationController(rootViewController: homeVC)
            }
        }else {
            delegate.navController = UINavigationController(rootViewController: loginVC)
        }

        delegate.navController.isNavigationBarHidden = true
        delegate.window?.rootViewController = delegate.navController
        delegate.window?.makeKeyAndVisible()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token: \(deviceToken)")
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Token: \(token)")
        
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
}

// MARK: MessagingDelegate methods
extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        UserDefaults.standard.set(fcmToken, forKey: kFcmToken)
        UserDefaults.standard.synchronize()
        
        let tokenDict = ["token": fcmToken ?? ""]
        print(tokenDict)
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
    }
    
}
