//
//  profileManager.swift
//  trtcScenesDemo
//
//  Created by xcoderliu on 12/23/19.
//  Copyright © 2019 xcoderliu. All rights reserved.
//

import UIKit


let loginBaseUrl = "https://xxx.com/release/"



@objc class loginResultModel: NSObject, Codable {
    var token: String
    var phone: String
    var name: String
    var avatar: String
    var userId: String
    
    public init(userID: String) {
        userId = userID
        token = userID
        phone = userID
        name = userID
        avatar = "https://wx4.sinaimg.cn/large/006DFKaTly1fhvvnpuwe2j30gq0gqmy4.jpg"
        super.init()
    }
}


@objc public class TimProfileManager: NSObject {
    @objc public static let shared = TimProfileManager()
    private override init() {}

    var sessionId: String = ""
    var curUserModel: loginResultModel? = nil

    
/// 根据手机号查询用户信息
   /// - Parameters:
   ///   - phone: 手机号码
   ///   - success: 成功回调
   ///   - failed: 失败回调
   ///   - error: 错误信息
   @objc public func queryUserInfo(phone: String, success: @escaping (userModel)->Void,
                             failed: @escaping (_ error: String)->Void) {
       if phone.count > 0 {
           success(userModel.init(userID: phone))
       } else {
           failed("错误的userID")
       }
   }
    
/// 查询单个用户信息
   /// - Parameters:
   ///   - userID: 用户id
   ///   - success: 成功回调
   ///   - failed: 失败回调
   ///   - error: 错误信息
   @objc public func queryUserInfo(userID: String, success: @escaping (userModel)->Void,
                                   failed: @escaping (_ error: String)->Void) {
       if userID.count > 0 {
           success(userModel.init(userID: userID))
       } else {
           failed("错误的userID")
       }
   }

    /// 查询多个用户信息
    /// - Parameters:
    ///   - userIDs: 用户id列表
    ///   - success: 成功回调
    ///   - failed: 失败回调
    ///   - error : 错误信息
    @objc public func queryUserListInfo(userIDs: [String], success: @escaping ([userModel])->Void,
                                  failed: @escaping (_ error: String)->Void) {
        if userIDs.count > 0 {
            var models: [userModel] = []
            for userID in userIDs {
                models.append(userModel.init(userID: userID))
            }
            success(models)
        } else {
            failed("空userIDs")
        }
    }
}

@objc public class userModel: NSObject, Codable {
    var phone: String?
    var name: String
    var avatar: String
    var userId: String
    
    public init(userID: String) {
          userId = userID
          name = userID
          avatar = "https://wx4.sinaimg.cn/large/006DFKaTly1fhvvnpuwe2j30gq0gqmy4.jpg"
          phone = userID
          super.init()
      }
}
