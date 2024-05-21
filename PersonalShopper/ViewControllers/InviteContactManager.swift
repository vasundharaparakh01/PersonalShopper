//
//  InviteContactManager.swift
//  appName
//
//  Created by macbook on 23/12/22.
//

import Foundation
import Contacts
import MessageUI

class InviteContactManager {
    
    private init() {}
    
    static let shared = InviteContactManager()
    
    var friendList = [String]()
    var friendContact = [Dictionary<String, Any>]()
    
    func fetchAllContactFromPhone() {
        let queue = DispatchQueue(label: "contact_thread",qos: .background)
        queue.async {
            self.fetchContactFromPhone()
        }
    }
    
    func fetchContactFromPhone() {
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        var mobileArray = [String]()
        
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber {
                        // Get The Mobile Number
                        var mobile = number.stringValue
                        mobile = mobile.replacingOccurrences(of: " ", with: "")
                        mobile = mobile.replacingOccurrences(of: "(", with: "")
                        mobile = mobile.replacingOccurrences(of: ")", with: "")
                        mobile = mobile.replacingOccurrences(of: "-", with: "")
                        
                        mobileArray.append(mobile)
                    }
                }
            }
//            DispatchQueue.main.async {
                self.callSyncContactApi(phonebook: mobileArray)
//            }
        } catch {
            print("unable to fetch contacts")
        }
        
    }
    
    func callSyncContactApi(phonebook: [String]) {
        
        var phoneArray = phonebook
        
        if let userData = UserDefaults.standard.value(forKey: UserDefaults.Keys.UserInfo.rawValue) as? Data {
            do {
                // Decode Data
                let userInfoModel = try JSONDecoder().decode(UserInfoModel.self, from: userData)
                if let number = userInfoModel.mobilenumber, number != "" {
                    
                    let filtered = phonebook.filter { $0 != number }
                    print(filtered)
                    phoneArray = filtered
                }
            } catch {
                print("Unable to Encode Note (\(error))")
            }
            
        }

        let url = BaseUrl + kSyncContactApi
        let parameters: [String: Any] = ["phonebook": phoneArray]
        DispatchQueue.main.async {
            APIService.sharedInstance.postDataOnServerByAccessToken(loadingText: "Syncing contacts to fetch your recommended friends on appName!", url: url, params: parameters, view: UIView()) { success, response, responseJson, errorMsg  in
                
                if success {
                    if let data = response {
                        do {
                            let modelObj = try JSONDecoder().decode(ContactModel.self, from: data)
                            
                            if modelObj.success == true {
                                self.callGetInviteFriendsListApi()
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        
    }
    
    func callGetInviteFriendsListApi() {
        
        let url = BaseUrl + kGetInviteFriendListApi
        
        APIService.sharedInstance.getDataFromServerByAccessToken(url: url, view: UIView()) { success, response, responseJson, errorMsg  in
            if success {
                if let data = response {
                    do {
                        let modelObj = try JSONDecoder().decode(InviteFriendListModel.self, from: data)
                        if modelObj.success == true {
                            self.friendList = modelObj.data?.inviteList ?? []
                            print("Friend list:====", self.friendList)
                            let queue = DispatchQueue(label: "contact_thread",qos: .background)
                            queue.async {
                                self.fetchAllContactFromPhoneForFilterContact()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        
    }
    
    func fetchAllContactFromPhoneForFilterContact() {
        
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber {
                        // Get The Mobile Number
                        var mobile = number.stringValue
                        mobile = mobile.replacingOccurrences(of: " ", with: "")
                        mobile = mobile.replacingOccurrences(of: "(", with: "")
                        mobile = mobile.replacingOccurrences(of: ")", with: "")
                        mobile = mobile.replacingOccurrences(of: "-", with: "")
                        print(mobile)
                        
                        var image = UIImage()
                        var dict = Dictionary<String, Any>()
                        
                        dict["mobile"] = mobile
                        
//                        if let imageData = contact.imageData {
//                            if let myImage = UIImage(data: imageData) {
//                                image = myImage
//                                dict["image"] = image
//                            }
//                        }
                        dict["name"] = "\(contact.givenName) \(contact.familyName)"
                        self.friendContact.append(dict)
                    }
                }
                
                let queue = DispatchQueue(label: "contact_thread",qos: .background)
                queue.async {
                    let filteredArray = self.friendContact
                        .filter{ self.friendList.contains($0["mobile"] as! String) }
                    SharedClass.sharedInstance.contacts = filteredArray
                    UserDefaults.standard.set(false, forKey: UserDefaults.Keys.IsContacts.rawValue)
                    UserDefaults.standard.synchronize()
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
        
    }
    
    
}
