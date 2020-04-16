//
//  TIMHelper.swift
//  NewDemo
//
//  Created by botu on 2020/4/2.
//  Copyright © 2020 slowdony. All rights reserved.
//

import UIKit


enum VideoUserRemoveReason: UInt32 {
    case leave = 0
    case reject
    case noresp
    case busy
}


class TIMHelper:NSObject{
    @objc public static let shared = TIMHelper()
    var callVC :TimVideoCallViewController? = nil
    var containViewController : UIViewController!
    
    @objc public func initTim(application:UIApplication,launchOptions:NSDictionary) {
          registNotification()
           if (TIM_SDKAPPID == 0) {
              let alert = UIAlertView(title: "Demo 尚未配置 SDKAPPID，请前往 TIMConfig 配置", message: nil, delegate: self, cancelButtonTitle: "知道了")
              alert.show()
              return
          }else{
              TUIKit.sharedInstance().setup(withAppId: NSInteger(TIM_SDKAPPID))
          }
          
          self.loginTim {
            TimTRTCVideoCall.shared.delegate = self
          }
    }
    
    
    
}



extension TIMHelper{
    @objc public func callUser(userID:String,parentVc:UIViewController){
        let usersss =  userModel(userID:userID)
        containViewController = parentVc
          var list:[TimVideoCallUserModel] = []
         var userIds: [String] = []
  //       for userModel in usersss {
  //           list.append(self.covertUser(user: userModel))
             userIds.append(usersss.userId)
  //       }
         self.showCallVC(invitedList: list)
     TimTRTCVideoCall.shared.invite(userIds: userIds, type: .video)
   }
    
    /// show calling view
    /// - Parameters:
    ///   - invitedList: invitee userlist
    ///   - sponsor: passive call should not be nil,
    ///     otherwise sponsor call this mothed should ignore this parameter
    func showCallVC(invitedList: [TimVideoCallUserModel], sponsor: TimVideoCallUserModel? = nil) {
        callVC = TimVideoCallViewController(sponsor: sponsor)
        callVC?.dismissBlock = {[weak self] in
            guard let self = self else {return}
            self.callVC = nil
        }
        if let vc = callVC {
            vc.modalPresentationStyle = .fullScreen
            vc.resetWithUserList(users: invitedList, isInit: true)
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                if let navigationVC = topController as? UINavigationController {
                    if navigationVC.viewControllers.contains(containViewController) {
                     containViewController.present(vc, animated: false, completion: nil)
                    } else {
                        navigationVC.popToRootViewController(animated: false)
                        navigationVC.pushViewController(containViewController, animated: false)
                        navigationVC.present(vc, animated: false, completion: nil)
                    }
                } else {
                    topController.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
}





//MARK:--------------------TRTCVideoCallDelegate-----------------------------
extension TIMHelper :TRTCVideoCallDelegate {
    func onInvited(sponsor: String, userIds: [String], isFromGroup: Bool) {
        debugPrint("📳 onInvited sponsor:\(sponsor) userIds:\(userIds)")
        TimProfileManager.shared.queryUserInfo(userID: sponsor, success: { [weak self] (user) in
            guard let self = self else {return}
            TimProfileManager.shared.queryUserListInfo(userIDs: userIds, success: { (usermodels) in
                var list:[TimVideoCallUserModel] = []
                for userModel in usermodels {
                    list.append(self.covertUser(user: userModel))
                }
                self.showCallVC(invitedList: list, sponsor: self.covertUser(user: user, isEnter: true))
            }) { (error) in
                
            }
        }) { (error) in
            
        }
    }
    
    func onGroupCallInviteeListUpdate(userIds: [String]) {
        debugPrint("📳 onGroupCallInviteeListUpdate userIds:\(userIds)")
    }
    
    func onUserEnter(uid: String) {
        debugPrint("📳 onUserEnter: \(uid)")
        if let vc = callVC {
            TimProfileManager.shared.queryUserInfo(userID: uid, success: { [weak self, weak vc] (userModel) in
                guard let self = self else {return}
                vc?.enterUser(user: self.covertUser(user: userModel, isEnter: true))
                vc?.view.makeToast("\(userModel.name) 进入通话")
            }) { (error) in
                
            }
        }
    }
    
    func onUserLeave(uid: String) {
        debugPrint("📳 onUserLeave: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .leave)
    }
    
    func onReject(uid: String) {
        debugPrint("📳 onReject: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .reject)
    }
    
    func onNoResp(uid: String) {
        debugPrint("📳 onNoResp: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .noresp)
    }
    
    func onCallingError(uid: String, code: Int) {
        debugPrint("📳 onCallingError: \(uid), errorCode: \(code)")
    }
    
    func onLineBusy(uid: String) {
        debugPrint("📳 onLineBusy: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .busy)
    }
    
    func onCallingCancel() {
        debugPrint("📳 onCallingCancel")
        if let vc = callVC {
            self.containViewController.view.makeToast("\((vc.curSponsor?.name) ?? "")通话取消")
            vc.disMiss()
        }
    }
    
    func onCallingTimeOut() {
        debugPrint("📳 onCallingTimeOut")
        if let vc = callVC {
            self.containViewController.view.makeToast("通话超时")
            vc.disMiss()
        }
    }
    
    func onCallEnd() {
        debugPrint("📳 onCallEnd")
        if let vc = callVC {
            vc.disMiss()
        }
    }
    
    func onUserVideoAvailable(uid: String, available: Bool) {
        debugPrint("📳 onUserVideoAvailable , uid: \(uid), available: \(available)")
        if let vc = callVC {
            if let user = vc.getUserById(userId: uid) {
                var newUser = user
                newUser.isEnter = true
                newUser.isVideoAvaliable = available
                vc.updateUser(user: newUser)
            } else {
                TimProfileManager.shared.queryUserInfo(userID: uid, success: { (userModel) in
                    var newUser = self.covertUser(user: userModel, isEnter: true)
                    newUser.isVideoAvaliable = available
                    vc.enterUser(user: newUser)
                }) { (error) in
                    
                }
            }
        }
    }
    
    func covertUser(user: userModel,
                        isEnter: Bool = false) -> TimVideoCallUserModel {
        var dstUser = TimVideoCallUserModel()
        dstUser.name = user.name
        dstUser.avatarUrl = user.avatar
        dstUser.userId = user.userId
        dstUser.isEnter = isEnter
        if let vc = callVC {
            if let oldUser = vc.getUserById(userId: user.userId) {
                dstUser.isVideoAvaliable = oldUser.isVideoAvaliable
            }
        }
        return dstUser
    }
    
    func removeUserFromCallVC(uid: String, reason: VideoUserRemoveReason = .noresp) {
        if let vc = callVC {
            TimProfileManager.shared.queryUserInfo(userID: uid, success: { [weak self, weak vc] (userModel) in
                guard let self = self else {return}
                let userInfo = self.covertUser(user: userModel)
                vc?.leaveUser(user: userInfo)
                var toast = "\(userInfo.name)"
                switch reason {
                case .reject:
                    toast += "拒绝了通话"
                    break
                case .leave:
                    toast += "离开了通话"
                    break
                case .noresp:
                    toast += "未响应"
                    break
                case .busy:
                    toast += "忙线"
                    break
                }
                vc?.view.makeToast(toast)
                self.containViewController.view.makeToast(toast)
            }) { (error) in
                
            }
        }
    }
}






//MARK:--------------------初始化-----------------------------
extension TIMHelper{

//MARK: - notification
    func loginTim(success: @escaping (() -> Void)){
        let userSig = GenerateTestUserSig.genTestUserSig("15202917911")
        TimTRTCVideoCall.shared.login(sdkAppID: UInt32(TIM_SDKAPPID), user: "15202917911", userSig: userSig, success: {
            TimProfileManager.shared.curUserModel = loginResultModel(userID: "15202917911")
            success()
        }) { (code, msg) in
        
        }
    }
    
//MARK: - notification
   func registNotification() {
       if #available(iOS 8.0, *) {
           UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.sound, .alert, .badge], categories: nil))
           UIApplication.shared.registerForRemoteNotifications()
       } else {
           UIApplication.shared.registerForRemoteNotifications(matching: [.sound, .alert, .badge])
       }
   }
}



