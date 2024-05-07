//
//  AppConstant.swift
//  MYFAVS
//
//  Created by iOS Dev on 20/06/22.
//

import UIKit
import GoogleSignIn


//let sceneDelegate = UIApplication.shared.delegate as? SceneDelegate
//let APPDELEGATE = UIApplication.shared.delegate as! SceneDelegate


let signInConfig = GIDConfiguration(clientID: "201782800631-0lmf83igrpf2vpeu2k6dc1d5rumn2mca.apps.googleusercontent.com")
let kFcmToken = "fcmToken"


// Base url
//let BaseUrl = "http://54.190.192.105:9127/api/V1/" // Dev
//let BaseUrl = "http://18.190.16.70:9127/api/V1/" // Prod
let BaseUrl = "https://admin.downloadmyfavs.com:444/api/V1/" // Prod

// Api endpoints
let kAuth = "auth/"
let kLoginApi = "signIn"
let kRegistrationApi = "signup"
let kVerifyOtpApi = "verifyEmail"
let kChangePasswordApi = "changePassword"
let kSignOutApi = "signOut"
let kSocialLoginApi = "social/signup"
let kForgetPasswordApi = "forgotPassword"
let kVerifyOtpForForgetPasswordApi = "verifyOtp"
let kResetPasswordApi = "resetPassword"


let kGetProfileApi = "profile/get"
let kUpdateProfileApi = "profile/user/update/"
//let kGetBannerImageApi = "bannerImage/get"
//let kGetBannerImageApi = "bannerImage/get?type="
let kGetBannerImageByCatIdApi = "bannerImage/getByCatId/"

let kGetCategoryApi = "category/get"
let kGetSubCategoryApi = "subcategory/get"
let kGetSubCategoryByCatIdApi = "subcategory/getbycatid/"
let kGetSubSubCategoryByCatIdApi = "subsubcategory/getbyid/"
let kGetSubSubCategoryBySubCatIdApi = "subsubcategory/getbysubcatid/"
let kGetNotificationsApi = "notifications/get"

let kGetInviteFriendListApi = "user/invites"


let kGetAllSizesChartApi = "sizechart/get"
let kGetSizesChartByCatIdApi = "sizechart/getbyCatId/"

let kGetSizesByCatIdApi = "size/getbyCatId/"
let kGetSizesBySubSubCatIdApi = "size/getbysubsubcatId/"


let kSyncContactApi = "user/sync"
let kSuggestedUsersApi = "user/suggesteusers"
let kSendConnectionRequestApi = "user/sendConnectionRequest"
let kWithdrawConnectionRequestApi = "user/userDisconnect/"

let kSuggestedFriendsApi = "user/suggestedFriends"
let kFriendListApi = "user/friendList"
let kSizePreferenceApi = "sizePreference/list"



let ksendConnectionResponseApi = "user/sendConnectionResponse"
let kFetchPendingRequestsApi = "user/fetchPendingRequests"
let kFetchPedingResponseApi = "user/fetchPedingResponse"


let kReportApi = "report"
    
    
let kCreateProductApi = "product/create"
let kGetProductApi = "product/get"
let kDeleteProductApi = "product/delete/"
let kUpdateProductApi = "product/update/"

let kCreateSizePreferenceApi = "sizePreference/create"
let kUpdateSizePreferenceApi = "sizePreference/update/"

let kGetProductFriendsFavApi = "product/friendsFav/"

let kFindMeApi = "user/findMe"

let kGetPolicyApi = "policy/get"
let kGetTermsApi = "terms/conditions/get"


//@@@ String lenght

let emailMaxLength                  =       80
let passwordMinLength               =       8
let passwordMaxLength               =       12
let mobileNumberMaxLength           =       16
let usernameMaxLength               =       16

//@@@ Validation strings

let blankUsername                   = "Please enter username."
let invalidUsername                 = "Please use only letters upper and lower case, numbers, underscore and periods."
let blankEmail                      = "Please enter email."
let invalidEmail                    = "Please enter valid email."
let blankPassword                   = "Please enter password."
let blankNewPassword                   = "Please enter new password."
let blankOldPassword                = "Please enter old password."
let invalidPassword                 = "Please enter password be alpha-numeric, must have upper and lower case, and at least one special character"
let mismatchPassowrdAndConfirmPassword = "Confirm password must match with password."
let blankMobileNumber               = "Please enter mobile number."
let invalidMobileNumber             = "Please enter valid mobile number."


//Success
let forgotPasswordSuccess = "An email has been sent to your email address. Follow the directions in the email to reset your password."

let logOutTitle         = "Logout"
let logOutSubTitle      = "Are you sure you want to logout?"

let appName         = "MyFavs"
let deleteTitle         = "Delete"
let deleteSubTitle      = "Do you want to delete?"

let sessionExpiredCheckMsg = "You need to be logged in to access this route"
let sessionExpiredTitle = "Login Session Expired"
let sessionExpiredSubTitle      = "You need to Login."

// Alert messages
let kSuccessfully = "Successfully!"
let kError = "Error!"
let kAlert = "Alert!"
let kSomethingWentWrong = "Something went wrong."



func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func hexStringToUIColor (hex:String, a: CGFloat = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: a
    )
}
