//
//  TimVideoPresentationController.swift
//  NewDemo
//
//  Created by botu on 2020/4/14.
//  Copyright © 2020 slowdony. All rights reserved.
//

import UIKit

class TimVideoPresentationController: UIPresentationController {
    
    public var controllerHeight:CGFloat = 200
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
         //get height from an objec of PresentBottomVC class
//         if case let vc as PresentBottomVC = presentedViewController {
//             controllerHeight = vc.controllerHeight
//         } else {
//             controllerHeight = UIScreen.main.bounds.width
//         }
         super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
     }
    
    
    public override var frameOfPresentedViewInContainerView: CGRect {
           return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
    }
}



// MARK: - add function to UIViewController to call easily
@objc extension UIViewController: UIViewControllerTransitioningDelegate {
    
    /// function to show the bottom view
    ///
    /// - Parameter vc: class name of bottom view
    @objc public func presentBottom(_ vc: UIViewController ) {
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    // function refers to UIViewControllerTransitioningDelegate
    @objc public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = TimVideoPresentationController(presentedViewController: presented, presenting: presenting)
        return present
    }
}
