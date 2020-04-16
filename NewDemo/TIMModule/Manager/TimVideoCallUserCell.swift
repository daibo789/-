//
//  VideoCallUserCell.swift
//  trtcScenesDemo
//
//  Created by xcoderliu on 1/17/20.
//  Copyright © 2020 xcoderliu. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

struct TimVideoCallUserModel: Equatable {
    var avatarUrl: String = ""
    var name: String = ""
    var userId: String = ""
    var isEnter: Bool = false
    var isVideoAvaliable: Bool = false
    
    static func == (lhs: TimVideoCallUserModel, rhs: TimVideoCallUserModel) -> Bool {
        if lhs.userId == rhs.userId {
                return true
        }
        return false
    }
}

class TimVideoCallUserCell: UICollectionViewCell {
   
    var userModel = TimVideoCallUserModel() {
        didSet {
            configModel(model: userModel)
        }
    }
    
    func configModel(model: TimVideoCallUserModel) {
        let noModel = model.userId.count == 0
        if !noModel {
            if userModel.userId != TimVideoCallUtils.shared.curUserId() {
                if let render = TimVideoCallViewController.getRenderView(userId: userModel.userId) {
                    if render.superview != self {
                        render.removeFromSuperview()
                        DispatchQueue.main.async {
                            render.frame = self.bounds
                        }
                        addSubview(render)
                        render.userModel = userModel
                    }
                } else {
                    print("error")
                }
            }
        }
    }
}
