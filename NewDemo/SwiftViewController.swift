//
//  SwiftViewController.swift
//  NewDemo
//
//  Created by botu on 2020/4/15.
//  Copyright © 2020 slowdony. All rights reserved.
//

import UIKit



var ballView : TimVieoWindowView!
class SwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 UserDefaults.standard.setValue("0", forKey: "ballViewSave")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showAciton(_ sender: Any) {
          if UserDefaults.standard.object(forKey: "ballViewSave")as! String == "1" {
            let aleat = UIAlertController(title: "提示", message:"当前已有悬浮窗", preferredStyle: UIAlertController.Style.alert)
                    let tempAction = UIAlertAction(title: "知道了", style: .cancel) { (action) in
                        
                    }
                    aleat.addAction(tempAction)
                    self.present(aleat, animated: true, completion: {
                    })
                }else{
                    ballView = TimVieoWindowView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
                    UserDefaults.standard.setValue("1", forKey: "ballViewSave")
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

}
