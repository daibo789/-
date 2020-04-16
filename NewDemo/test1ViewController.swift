//
//  test1ViewController.swift
//  NewDemo
//
//  Created by botu on 2020/4/8.
//  Copyright © 2020 slowdony. All rights reserved.
//

import UIKit
@objc protocol DragViewDelegate {
    func dragviewDidSelect()
}

class test1ViewController: UIViewController {
    var callVC: TimVideoCallViewController? = nil
    weak var delegate:DragViewDelegate?
    @objc var dismissBlock: ((_ res:Bool)->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        //设置视图点击手势
               let tap = UITapGestureRecognizer(target: self, action: #selector(didselect))
        self.view.addGestureRecognizer(tap)
        
//        self.view.isHidden = true

        
        // Do any additional setup after loading the view.
    }
    
    @objc func didselect() {
           self.delegate?.dragviewDidSelect()
       }
       
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.dismiss(animated: true) {
//            self.view.frame = UIScreen.main.bounds
//            UIApplication.shared.keyWindow?.addSubview(self.view)
//        }
    }

    static var dddddd = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test1ViewController.dddddd = !test1ViewController.dddddd
        dismissBlock?(test1ViewController.dddddd)
        //保存触摸起始点位置
        if (startPoint == nil) {
            let point = touches.first?.location(in: self.view)
            startPoint = point
        }
               
    }
    
    @IBAction func zhujiao(_ sender: Any) {

       TIMHelper.shared.callUser(userID: "10a71f5ac27c4c528dc409f912603e9a", parentVc: self)
    }
    
    
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
                    if navigationVC.viewControllers.contains(self) {
                        present(vc, animated: false, completion: nil)
                    } else {
                        navigationVC.popToRootViewController(animated: false)
                        navigationVC.pushViewController(self, animated: false)
                        navigationVC.present(vc, animated: false, completion: nil)
                    }
                } else {
                    topController.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private var startPoint:CGPoint!
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //计算位移=当前位置-起始位置
        let point = touches.first!.location(in: self.view)
               let dx = point.x - startPoint.x
               let dy = point.y - startPoint.y
               
               //计算移动后的view中心点
        var newcenter = CGPoint.init(x:self.view.center.x + dx, y:self.view.center.y + dy);
               
               /* 限制用户不可将视图托出屏幕 */
               let halfx = self.view.bounds.midX
               
               //x坐标左边界
               newcenter.x = max(halfx, newcenter.x)
               //x坐标右边界
               newcenter.x = min((self.view.superview?.bounds.size.width)! - halfx, newcenter.x)
               
               //y坐标同理
               let halfy = self.view.bounds.midY
               newcenter.y = max(halfy, newcenter.y)
               newcenter.y = min((self.view.superview?.bounds.size.height)! - halfy, newcenter.y)
               
               //移动view
               self.view.center = newcenter
      
    }

}
