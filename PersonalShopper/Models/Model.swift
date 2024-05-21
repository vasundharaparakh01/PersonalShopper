//
//  SignupModel.swift
//  appName
//
//  Created by iOS Dev on 20/06/22.
//

// MARK: - Signup
struct SignupModel : Codable {
    let success : Bool?
    let data : SignupDataModel?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(SignupDataModel.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct SignupDataModel : Codable {
    let email : String?
    let otp : String?
    let token : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case otp = "otp"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}

// MARK: - Verify OTP
struct VerifyOtpModel : Codable {
    let success : Bool?
    let message : String?
    let data : UserDataModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case data = "data"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(UserDataModel.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

// MARK: - UserDataModel
struct UserDataModel : Codable {
    let accessToken : String?
    let userInfo : UserInfoModel?

    enum CodingKeys: String, CodingKey {

        case accessToken = "accessToken"
        case userInfo = "userInfo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        userInfo = try values.decodeIfPresent(UserInfoModel.self, forKey: .userInfo)
    }

}

// MARK: - UserInfoModel
struct UserInfoModel : Codable {
    let id : String?
    let isDeleted : Bool?
    let isVerified : Bool?
    let provider : [String]?
    let profilePic : String?
    let username : String?
    let email : String?
    let mobilenumber : String?
    let connections : [Connections]?
    let phoneBook : [String]?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?
    let isBlocked : Bool?
    let about : String?
    let findByMobile : Bool?
    let defaultBanner : Int?
    let deviceTokens : [DeviceTokens]?
    let notificationCount : Int?
    
    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case isDeleted = "isDeleted"
        case isVerified = "isVerified"
        case provider = "provider"
        case profilePic = "profilePic"
        case username = "username"
        case email = "email"
        case mobilenumber = "mobilenumber"
        case connections = "connections"
        case phoneBook = "phoneBook"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case isBlocked = "isBlocked"
        case about = "about"
        case findByMobile = "findByMobile"
        case defaultBanner = "defaultBanner"
        case deviceTokens = "deviceTokens"
        case notificationCount = "notificationCount"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
        provider = try values.decodeIfPresent([String].self, forKey: .provider)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobilenumber = try values.decodeIfPresent(String.self, forKey: .mobilenumber)
        connections = try values.decodeIfPresent([Connections].self, forKey: .connections)
        phoneBook = try values.decodeIfPresent([String].self, forKey: .phoneBook)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        findByMobile = try values.decodeIfPresent(Bool.self, forKey: .findByMobile)
        defaultBanner = try values.decodeIfPresent(Int.self, forKey: .defaultBanner)
        deviceTokens = try values.decodeIfPresent([DeviceTokens].self, forKey: .deviceTokens)
        notificationCount = try values.decodeIfPresent(Int.self, forKey: .notificationCount)

    }

}

struct DeviceTokens : Codable {
    let fcmToken : String?
    let deviceType : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case fcmToken = "fcmToken"
        case deviceType = "deviceType"
        case id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fcmToken = try values.decodeIfPresent(String.self, forKey: .fcmToken)
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

struct FindMeModel : Codable {
    let success : Bool?
    let message : String?
    let data : FindMeInfoModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(FindMeInfoModel.self, forKey: .data)
    }

}

struct FindMeInfoModel : Codable {
    let id : String?
    let isDeleted : Bool?
    let isVerified : Bool?
    let provider : [String]?
    let profilePic : String?
    let username : String?
    let email : String?
    let mobilenumber : String?
    let connections : [String]?
    let phoneBook : [String]?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?
    let isBlocked : Bool?
    let about : String?
    let findByMobile : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case isDeleted = "isDeleted"
        case isVerified = "isVerified"
        case provider = "provider"
        case profilePic = "profilePic"
        case username = "username"
        case email = "email"
        case mobilenumber = "mobilenumber"
        case connections = "connections"
        case phoneBook = "phoneBook"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case isBlocked = "isBlocked"
        case about = "about"
        case findByMobile = "findByMobile"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
        provider = try values.decodeIfPresent([String].self, forKey: .provider)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        mobilenumber = try values.decodeIfPresent(String.self, forKey: .mobilenumber)
        connections = try values.decodeIfPresent([String].self, forKey: .connections)
        phoneBook = try values.decodeIfPresent([String].self, forKey: .phoneBook)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        findByMobile = try values.decodeIfPresent(Bool.self, forKey: .findByMobile)
    }

}

struct Connections : Codable {
    let id : String?
    let profilePic : String?
    let username : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case profilePic = "profilePic"
        case username = "username"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }

}

// MARK: - LoginModel
struct LoginModel : Codable {
    let success : Bool?
    let message : String?
    let data : UserDataModel?
    let error : ErrorModel?
    

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(UserDataModel.self, forKey: .data)
        error = try values.decodeIfPresent(ErrorModel.self, forKey: .error)
    }

}

struct ErrorModel : Codable {
    let email : String?
    let otp : String?
    let token : String?
    

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case otp = "otp"
        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        otp = try values.decodeIfPresent(String.self, forKey: .otp)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}


// MARK: - BannerImageModel
struct BannerImageModel : Codable {
    let success : Bool?
    let message : String?
    let data : [BannerImageDataModel]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([BannerImageDataModel].self, forKey: .data)
    }

}

struct BannerImageDataModel : Codable {
    let id : String?
    let banner : [String]?
    let type : String?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case banner = "banner"
        case type = "type"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        banner = try values.decodeIfPresent([String].self, forKey: .banner)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}

// MARK: - ProfileModel
struct ProfileModel : Codable {
    let success : Bool?
    let message : String?
    let data : UserInfoModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(UserInfoModel.self, forKey: .data)
    }

}

// MARK: - CategoryModel
struct CategoryModel : Codable {
    let success : Bool?
    let message : String?
    let data : [CategoryDataModel]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([CategoryDataModel].self, forKey: .data)
    }

}

struct CategoryDataModel : Codable {
    let id : String?
    let name : String?
    let description : String?
    let code : Int?
    let image : String?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
        case description = "description"
        case code = "code"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}


// MARK: - SubCategoryModel
struct SubCategoryModel : Codable {
    let success : Bool?
    let message : String?
    let data : [SubCategoryDataModel]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SubCategoryDataModel].self, forKey: .data)
    }

}

struct SubCategoryDataModel : Codable {
    let id : String?
    let name : String?
    let catId : CatIdModel?
    let code : Int?
    let description : String?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?
    let sizeFormats : [SizeFormats]?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
        case catId = "catId"
        case code = "code"
        case description = "description"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case sizeFormats = "sizeFormats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        catId = try values.decodeIfPresent(CatIdModel.self, forKey: .catId)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        sizeFormats = try values.decodeIfPresent([SizeFormats].self, forKey: .sizeFormats)
    }

}

struct CatIdModel : Codable {
    let id : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


// MARK: - SubSubCategoryModel
struct SubSubCategoryModel : Codable {
    let success : Bool?
    let message : String?
    let data : [SubSubCategoryDataModel]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SubSubCategoryDataModel].self, forKey: .data)
    }

}

struct SubSubCategoryDataModel : Codable {
    let id : String?
    let name : String?
    let usSize : String?
    let ukSize : String?
    let catId : CatIdModel?
    let subCatId : SubCatIdModel?
    let subsubCatPrefferedSize : [SubsubCatPrefferedSizeModel]?
    let description : String?
    let createdBy : String?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
        case usSize = "usSize"
        case ukSize = "ukSize"
        case catId = "catId"
        case subCatId = "subCatId"
        case subsubCatPrefferedSize = "subsubCatPrefferedSize"
        case description = "description"
        case createdBy = "createdBy"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        usSize = try values.decodeIfPresent(String.self, forKey: .usSize)
        ukSize = try values.decodeIfPresent(String.self, forKey: .ukSize)
        catId = try values.decodeIfPresent(CatIdModel.self, forKey: .catId)
        subCatId = try values.decodeIfPresent(SubCatIdModel.self, forKey: .subCatId)
        subsubCatPrefferedSize = try values.decodeIfPresent([SubsubCatPrefferedSizeModel].self, forKey: .subsubCatPrefferedSize)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}

struct SubCatIdModel : Codable {
    let id : String?
    let name : String?
    let sizeFormats : [SizeFormats]?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
        case sizeFormats = "sizeFormats"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        sizeFormats = try values.decodeIfPresent([SizeFormats].self, forKey: .sizeFormats)
    }

}

struct SubsubCatPrefferedSizeModel : Codable {
    let id : String?
    let size : String?
    let sizeType : String?
    let subsubcatId : String?
    let userId : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case size = "size"
        case sizeType = "sizeType"
        case subsubcatId = "subsubcatId"
        case userId = "userId"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        sizeType = try values.decodeIfPresent(String.self, forKey: .sizeType)
        subsubcatId = try values.decodeIfPresent(String.self, forKey: .subsubcatId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}

struct SizeFormats : Codable {
    let sizes : [String]?
    let sizeType : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case sizes = "sizes"
        case sizeType = "sizeType"
        case id = "_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sizes = try values.decodeIfPresent([String].self, forKey: .sizes)
        sizeType = try values.decodeIfPresent(String.self, forKey: .sizeType)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}


// MARK: - SizeModel
struct SizeModel : Codable {
    let success : Bool?
    let message : String?
    let data : [SizeDataModel]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SizeDataModel].self, forKey: .data)
    }

}

struct SizeDataModel : Codable {
    let id : String?
    let title : String?
    let image : String?
    let category : String?
    let createdAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case title = "title"
        case image = "image"
        case category = "category"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}

// MARK: - SizeChartModel
struct SizeChartByCatModel : Codable {
    let success : Bool?
    let message : String?
    let data : [SizeChartByCatDataModel]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SizeChartByCatDataModel].self, forKey: .data)
    }

}

struct SizeChartByCatDataModel : Codable {
    let id : String?
    let catId : CatIdModel?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?
    let title : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case catId = "catId"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case title = "title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        catId = try values.decodeIfPresent(CatIdModel.self, forKey: .catId)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

}

// MARK: - ContactModel
struct ContactModel : Codable {
    let success : Bool?
    let message : String?
    let data : ContactDataModel?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ContactDataModel.self, forKey: .data)
    }

}

struct ContactDataModel : Codable {
    let id : String?
    let isDeleted : Bool?
    let isVerified : Bool?
    let provider : [String]?
    let profilePic : String?
    let username : String?
    let email : String?
    let password : String?
    let mobilenumber : String?
    let connections : [String]?
    let phoneBook : [String]?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?
    let isBlocked : Bool?
    let about : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case isDeleted = "isDeleted"
        case isVerified = "isVerified"
        case provider = "provider"
        case profilePic = "profilePic"
        case username = "username"
        case email = "email"
        case password = "password"
        case mobilenumber = "mobilenumber"
        case connections = "connections"
        case phoneBook = "phoneBook"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case isBlocked = "isBlocked"
        case about = "about"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
        provider = try values.decodeIfPresent([String].self, forKey: .provider)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        mobilenumber = try values.decodeIfPresent(String.self, forKey: .mobilenumber)
        connections = try values.decodeIfPresent([String].self, forKey: .connections)
        phoneBook = try values.decodeIfPresent([String].self, forKey: .phoneBook)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        about = try values.decodeIfPresent(String.self, forKey: .about)
    }

}


// MARK: - SuggestedUsersModel
struct SuggestedUsersModel : Codable {
    let success : Bool?
    let message : String?
    let data : [SuggestedUsersModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SuggestedUsersModelData].self, forKey: .data)
    }

}

struct SuggestedUsersModelData : Codable {
    let id : String?
    let profilePic : String?
    let username : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case profilePic = "profilePic"
        case username = "username"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }

}

// MARK: - SendConnectionRequestModel
struct SendConnectionRequestModel : Codable {
    let success : Bool?
    let message : String?
    let data : SendConnectionRequestModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(SendConnectionRequestModelData.self, forKey: .data)
    }

}

struct SendConnectionRequestModelData : Codable {
    let requester : String?
    let recipient : String?
    let status : String?
    let id : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case requester = "requester"
        case recipient = "recipient"
        case status = "status"
        case id = "_id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requester = try values.decodeIfPresent(String.self, forKey: .requester)
        recipient = try values.decodeIfPresent(String.self, forKey: .recipient)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}


// MARK: - PendingRequestModel
struct PendingRequestModel : Codable {
    let success : Bool?
    let message : String?
    let data : [PendingRequestModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PendingRequestModelData].self, forKey: .data)
    }

}

struct PendingRequestModelData : Codable {
    let recipient : String?
    let requesters : [Requesters]?

    enum CodingKeys: String, CodingKey {

        case recipient = "recipient"
        case requesters = "requesters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recipient = try values.decodeIfPresent(String.self, forKey: .recipient)
        requesters = try values.decodeIfPresent([Requesters].self, forKey: .requesters)
    }

}

struct Requesters : Codable {
    let requesterId : String?
    let username : String?
    let profilePicture : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case requesterId = "requesterId"
        case username = "username"
        case profilePicture = "profilePicture"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requesterId = try values.decodeIfPresent(String.self, forKey: .requesterId)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}


// MARK: - PendingResponseModel
struct PendingResponseModel : Codable {
    let success : Bool?
    let message : String?
    let data : [PendingResponseModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PendingResponseModelData].self, forKey: .data)
    }

}

struct PendingResponseModelData : Codable {
    let requester : String?
    let recipients : [Recipients]?

    enum CodingKeys: String, CodingKey {

        case requester = "requester"
        case recipients = "recipients"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requester = try values.decodeIfPresent(String.self, forKey: .requester)
        recipients = try values.decodeIfPresent([Recipients].self, forKey: .recipients)
    }

}

struct Recipients : Codable {
    let recipientId : String?
    let username : String?
    let profilePicture : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case recipientId = "recipientId"
        case username = "username"
        case profilePicture = "profilePicture"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        recipientId = try values.decodeIfPresent(String.self, forKey: .recipientId)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}


// MARK: - PolicyModel
struct PolicyModel : Codable {
    let success : Bool?
    let message : String?
    let data : [PolicyModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PolicyModelData].self, forKey: .data)
    }

}

struct PolicyModelData : Codable {
    let id : String?
    let name : String?
    let policyText : String?
    let isDeleted : Bool?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case name = "name"
        case policyText = "term"
        case isDeleted = "isDeleted"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        policyText = try values.decodeIfPresent(String.self, forKey: .policyText)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}


struct SendConnectionResponseModel : Codable {
    let success : Bool?
    let message : String?
//    let data : Data?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
//        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
//        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }

}


// MARK: - ProductModel
struct ProductModel : Codable {
    let success : Bool?
    let message : String?
    let data : ProductModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(ProductModelData.self, forKey: .data)
    }

}

struct ProductModelData : Codable {
    let catId : String?
    let subCatId : String?
    let subSubCatId : String?
    let size : String?
    let name : String?
    let description : String?
    let images : [ImageModel]?
    let isOnline : Bool?
    let userId : String?
    let productlink : String?
    let location : String?
    let id : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case catId = "catId"
        case subCatId = "subCatId"
        case subSubCatId = "subSubCatId"
        case size = "size"
        case name = "name"
        case description = "description"
        case images = "images"
        case isOnline = "IsOnline"
        case userId = "userId"
        case productlink = "productlink"
        case location = "location"
        case id = "_id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        subCatId = try values.decodeIfPresent(String.self, forKey: .subCatId)
        subSubCatId = try values.decodeIfPresent(String.self, forKey: .subSubCatId)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        images = try values.decodeIfPresent([ImageModel].self, forKey: .images)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        productlink = try values.decodeIfPresent(String.self, forKey: .productlink)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}


struct ImageModel : Codable {
    let url : String?
    let order : Int?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case order = "order"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
    }

}


// MARK: - GetAllProductModel
struct GetAllProductModel : Codable {
    let success : Bool?
    let message : String?
    let data : GetAllProductModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(GetAllProductModelData.self, forKey: .data)
    }

}

struct GetAllProductModelData : Codable {
    let items : [GetAllProductModelDataItems]?
    let totalPages : Int?
    let currentPage : Int?
    let filteredDocuments : Int?

    enum CodingKeys: String, CodingKey {

        case items = "items"
        case totalPages = "totalPages"
        case currentPage = "currentPage"
        case filteredDocuments = "filteredDocuments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([GetAllProductModelDataItems].self, forKey: .items)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        currentPage = try values.decodeIfPresent(Int.self, forKey: .currentPage)
        filteredDocuments = try values.decodeIfPresent(Int.self, forKey: .filteredDocuments)
    }

}

struct GetAllProductModelDataItems : Codable {
    let id : String?
    let catId : String?
    let subCatId : String?
    let subSubCatId : String?
    let size : String?
    let sizeType : String?
    let name : String?
    let description : String?
    let images : [ImageModel]?
    let isOnline : Bool?
    let userId : String?
    let productlink : String?
    let location : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?
    let categories : Categories?
    let subcategories : Subcategories?
    let subsubcategories : [Subsubcategories]?
    
    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case catId = "catId"
        case subCatId = "subCatId"
        case subSubCatId = "subSubCatId"
        case size = "size"
        case sizeType = "sizeType"
        case name = "name"
        case description = "description"
        case images = "images"
        case isOnline = "IsOnline"
        case userId = "userId"
        case productlink = "productlink"
        case location = "location"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
        case categories = "categories"
        case subcategories = "subcategories"
        case subsubcategories = "subsubcategories"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        subCatId = try values.decodeIfPresent(String.self, forKey: .subCatId)
        subSubCatId = try values.decodeIfPresent(String.self, forKey: .subSubCatId)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        sizeType = try values.decodeIfPresent(String.self, forKey: .sizeType)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        images = try values.decodeIfPresent([ImageModel].self, forKey: .images)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        productlink = try values.decodeIfPresent(String.self, forKey: .productlink)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
        categories = try values.decodeIfPresent(Categories.self, forKey: .categories)
        subcategories = try values.decodeIfPresent(Subcategories.self, forKey: .subcategories)
        subsubcategories = try values.decodeIfPresent([Subsubcategories].self, forKey: .subsubcategories)
    }

}

struct Categories : Codable {
    let name : String?
    let description : String?
    let code : Int?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case description = "description"
        case code = "code"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}

struct Subcategories : Codable {
    let name : String?
    let catId : String?
    let sizeFormats : [SizeFormats]?
    let description : String?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case catId = "catId"
        case sizeFormats = "sizeFormats"
        case description = "description"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        sizeFormats = try values.decodeIfPresent([SizeFormats].self, forKey: .sizeFormats)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}

struct Subsubcategories : Codable {
    let name : String?
    let catId : String?
    let subCatId : String?
    let description : String?
    let createdBy : String?
    let image : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case catId = "catId"
        case subCatId = "subCatId"
        case description = "description"
        case createdBy = "createdBy"
        case image = "image"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        subCatId = try values.decodeIfPresent(String.self, forKey: .subCatId)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}



// MARK: - DeleteProductModel
struct DeleteProductModel : Codable {
    let success : Bool?
    let message : String?
    let data : DeleteProductModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(DeleteProductModelData.self, forKey: .data)
    }

}

struct DeleteProductModelData : Codable {
    let id : String?
    let catId : String?
    let subCatId : String?
    let subSubCatId : String?
    let size : String?
    let name : String?
    let description : String?
    let images : [ImageModel]?
    let isOnline : Bool?
    let userId : String?
    let productlink : String?
    let location : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case catId = "catId"
        case subCatId = "subCatId"
        case subSubCatId = "subSubCatId"
        case size = "size"
        case name = "name"
        case description = "description"
        case images = "images"
        case isOnline = "IsOnline"
        case userId = "userId"
        case productlink = "productlink"
        case location = "location"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        subCatId = try values.decodeIfPresent(String.self, forKey: .subCatId)
        subSubCatId = try values.decodeIfPresent(String.self, forKey: .subSubCatId)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        images = try values.decodeIfPresent([ImageModel].self, forKey: .images)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        productlink = try values.decodeIfPresent(String.self, forKey: .productlink)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}


// MARK: - SizesModel
struct SizesModel : Codable {
    let success : Bool?
    let message : String?
    let data : [SizesModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([SizesModelData].self, forKey: .data)
    }

}

struct SizesModelData : Codable {
    let id : String?
    let sizes : [String]?
    let subsubcatId : Subsubcategories?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case sizes = "sizes"
        case subsubcatId = "subsubcatId"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        sizes = try values.decodeIfPresent([String].self, forKey: .sizes)
        subsubcatId = try values.decodeIfPresent(Subsubcategories.self, forKey: .subsubcatId)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}


// MARK: - NotificationsModel
struct NotificationsModel : Codable {
    let success : Bool?
    let message : String?
    let data : [NotificationsModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([NotificationsModelData].self, forKey: .data)
    }

}

struct NotificationsModelData : Codable {
    let id : String?
    let title : String?
    let sender : SenderModel?
    let recivereId : String?
    let body : String?
    let notificationType : String?
    let show : Bool?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case title = "title"
        case sender = "senderId"
        case recivereId = "recivereId"
        case body = "body"
        case notificationType = "notificationType"
        case show = "show"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        sender = try values.decodeIfPresent(SenderModel.self, forKey: .sender)
        recivereId = try values.decodeIfPresent(String.self, forKey: .recivereId)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        show = try values.decodeIfPresent(Bool.self, forKey: .show)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}

struct SenderModel : Codable {
    let id : String?
    let username : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case username = "username"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
    }

}


// MARK: - SocialSignupModel
struct SocialSignupModel : Codable {
    let success : Bool?
    let message : String?
    let data : SocialSignupModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(SocialSignupModelData.self, forKey: .data)
    }

}

struct SocialSignupModelData : Codable {
    let accessToken : String?
    let userInfo : SocialSignupModelUserInfo?

    enum CodingKeys: String, CodingKey {

        case accessToken = "accessToken"
        case userInfo = "userInfo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        userInfo = try values.decodeIfPresent(SocialSignupModelUserInfo.self, forKey: .userInfo)
    }

}

struct SocialSignupModelUserInfo : Codable {
    let _id : String?
    let isBlocked : Bool?
    let isVerified : Bool?
    let provider : [String]?
    let profilePic : String?
    let deviceTokens : [DeviceTokens]?
    let username : String?
    let email : String?
    let password : String?
//    let connections : [String]?
    let friendsBook : [String]?
    let invites : [String]?
    let phoneBook : [String]?
    let findByMobile : Bool?
    let deviceType : String?
    let fcmToken : String?
    let createdAt : String?
    let updatedAt : String?
    let __v : Int?
    let uniqueId : String?
    let connections : [Connections]?

    
    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case isBlocked = "isBlocked"
        case isVerified = "isVerified"
        case provider = "provider"
        case profilePic = "profilePic"
        case deviceTokens = "deviceTokens"
        case username = "username"
        case email = "email"
        case password = "password"
        case connections = "connections"
        case friendsBook = "friendsBook"
        case invites = "invites"
        case phoneBook = "phoneBook"
        case findByMobile = "findByMobile"
        case deviceType = "deviceType"
        case fcmToken = "fcmToken"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case __v = "__v"
        case uniqueId = "uniqueId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
        provider = try values.decodeIfPresent([String].self, forKey: .provider)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        deviceTokens = try values.decodeIfPresent([DeviceTokens].self, forKey: .deviceTokens)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        connections = try values.decodeIfPresent([Connections].self, forKey: .connections)
        friendsBook = try values.decodeIfPresent([String].self, forKey: .friendsBook)
        invites = try values.decodeIfPresent([String].self, forKey: .invites)
        phoneBook = try values.decodeIfPresent([String].self, forKey: .phoneBook)
        findByMobile = try values.decodeIfPresent(Bool.self, forKey: .findByMobile)
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
        fcmToken = try values.decodeIfPresent(String.self, forKey: .fcmToken)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        uniqueId = try values.decodeIfPresent(String.self, forKey: .uniqueId)
    }

}

// MARK: - SignoutModel
struct SignoutModel : Codable {
    let success : Bool?
    let message : String?
    let data : SignoutModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(SignoutModelData.self, forKey: .data)
    }

}

struct SignoutModelData : Codable {
    let id : String?
    let isBlocked : Bool?
    let isVerified : Bool?
    let provider : [String]?
    let profilePic : String?
    let deviceTokens : [DeviceTokens]?
    let username : String?
    let email : String?
    let password : String?
    let mobilenumber : String?
    let connections : [String]?
    let friendsBook : [String]?
    let phoneBook : [String]?
    let findByMobile : Bool?
    let fcmToken : String?
    let deviceType : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case isBlocked = "isBlocked"
        case isVerified = "isVerified"
        case provider = "provider"
        case profilePic = "profilePic"
        case deviceTokens = "deviceTokens"
        case username = "username"
        case email = "email"
        case password = "password"
        case mobilenumber = "mobilenumber"
        case connections = "connections"
        case friendsBook = "friendsBook"
        case phoneBook = "phoneBook"
        case findByMobile = "findByMobile"
        case fcmToken = "fcmToken"
        case deviceType = "deviceType"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
        provider = try values.decodeIfPresent([String].self, forKey: .provider)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        deviceTokens = try values.decodeIfPresent([DeviceTokens].self, forKey: .deviceTokens)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        mobilenumber = try values.decodeIfPresent(String.self, forKey: .mobilenumber)
        connections = try values.decodeIfPresent([String].self, forKey: .connections)
        friendsBook = try values.decodeIfPresent([String].self, forKey: .friendsBook)
        phoneBook = try values.decodeIfPresent([String].self, forKey: .phoneBook)
        findByMobile = try values.decodeIfPresent(Bool.self, forKey: .findByMobile)
        fcmToken = try values.decodeIfPresent(String.self, forKey: .fcmToken)
        deviceType = try values.decodeIfPresent(String.self, forKey: .deviceType)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}


// MARK: - NotificationsModel
struct InviteFriendListModel : Codable {
    let success : Bool?
    let message : String?
    let data : InviteFriendListModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(InviteFriendListModelData.self, forKey: .data)
    }

}

struct InviteFriendListModelData : Codable {
    let inviteList : [String]?

    enum CodingKeys: String, CodingKey {

        case inviteList = "inviteList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        inviteList = try values.decodeIfPresent([String].self, forKey: .inviteList)
    }

}


// MARK: - SavePreferedSizeModel
struct SavePreferedSizeModel : Codable {
    let success : Bool?
    let message : String?
    let data : SavePreferedSizeModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(SavePreferedSizeModelData.self, forKey: .data)
    }

}

struct SavePreferedSizeModelData : Codable {
    let size : String?
    let subsubcatId : String?
    let sizeType : String?
    let userId : String?
    let id : String?
    let createdAt : String?
    let updatedAt : String?
    let v : Int?

    enum CodingKeys: String, CodingKey {

        case size = "size"
        case subsubcatId = "subsubcatId"
        case sizeType = "sizeType"
        case userId = "userId"
        case id = "_id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        subsubcatId = try values.decodeIfPresent(String.self, forKey: .subsubcatId)
        sizeType = try values.decodeIfPresent(String.self, forKey: .sizeType)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        v = try values.decodeIfPresent(Int.self, forKey: .v)
    }

}

// MARK: - FriendDetailsModel
struct FriendDetailsModel : Codable {
    let success : Bool?
    let message : String?
    let data : FriendDetailsModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(FriendDetailsModelData.self, forKey: .data)
    }

}

struct FriendDetailsModelData : Codable {
    let items : [GetAllProductModelDataItems]?
    let userDetail : UserDetail?

    enum CodingKeys: String, CodingKey {

        case items = "items"
        case userDetail = "userDetail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decodeIfPresent([GetAllProductModelDataItems].self, forKey: .items)
        userDetail = try values.decodeIfPresent(UserDetail.self, forKey: .userDetail)
    }

}

struct UserDetail : Codable {
    let id : String?
    let profilePic : String?
    let username : String?
    let connections : [String]?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case profilePic = "profilePic"
        case username = "username"
        case connections = "connections"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        connections = try values.decodeIfPresent([String].self, forKey: .connections)
    }

}

struct Images : Codable {
    let url : String?
    let order : Int?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case order = "order"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
    }

}

// MARK: - WithdrawnConnectionModel
struct WithdrawnConnectionModel : Codable {
    let success : Bool?
    let message : String?
    let data : WithdrawnConnectionModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(WithdrawnConnectionModelData.self, forKey: .data)
    }

}

struct WithdrawnConnectionModelData : Codable {
    let acknowledged : Bool?
    let deletedCount : Int?

    enum CodingKeys: String, CodingKey {

        case acknowledged = "acknowledged"
        case deletedCount = "deletedCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        acknowledged = try values.decodeIfPresent(Bool.self, forKey: .acknowledged)
        deletedCount = try values.decodeIfPresent(Int.self, forKey: .deletedCount)
    }

}


// MARK: - UserListModel
struct UserListModel : Codable {
    let success : Bool?
    let message : String?
    let data : UserListModelData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(UserListModelData.self, forKey: .data)
    }

}

struct UserListModelData : Codable {
    let docs : [UserListModelDataDocs]?
    let total : Int?
    let limit : Int?
    let page : Int?
    let pages : Int?

    enum CodingKeys: String, CodingKey {

        case docs = "docs"
        case total = "total"
        case limit = "limit"
        case page = "page"
        case pages = "pages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        docs = try values.decodeIfPresent([UserListModelDataDocs].self, forKey: .docs)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        pages = try values.decodeIfPresent(Int.self, forKey: .pages)
    }

}

struct UserListModelDataDocs : Codable {
    let id : String?
    let profilePic : String?
    var username = ""

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case profilePic = "profilePic"
        case username = "username"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        username = try values.decodeIfPresent(String.self, forKey: .username) ?? ""
    }

}

// MARK: - PrefferedSizeModel
struct PrefferedSizeModel : Codable {
    let success : Bool?
    let message : String?
    let data : [PrefferedSizeModelData]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([PrefferedSizeModelData].self, forKey: .data)
    }

}

struct PrefferedSizeModelData : Codable {
    let _id : String?
    let name : String?
    let image : String?
    let catId : String?
    let subCatId : String?
    let subsubCatPrefferedSize : [SubsubCatPrefferedSize]?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case name = "name"
        case image = "Image"
        case catId = "catId"
        case subCatId = "subCatId"
        case subsubCatPrefferedSize = "subsubCatPrefferedSize"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        catId = try values.decodeIfPresent(String.self, forKey: .catId)
        subCatId = try values.decodeIfPresent(String.self, forKey: .subCatId)
        subsubCatPrefferedSize = try values.decodeIfPresent([SubsubCatPrefferedSize].self, forKey: .subsubCatPrefferedSize)
    }

}

struct SubsubCatPrefferedSize : Codable {
    let _id : String?
    let size : String?
    let sizeType : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case size = "size"
        case sizeType = "sizeType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        size = try values.decodeIfPresent(String.self, forKey: .size)
        sizeType = try values.decodeIfPresent(String.self, forKey: .sizeType)
    }

}
