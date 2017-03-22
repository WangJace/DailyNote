//
//  WJContentViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/3/13.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

class WJContentViewController: WJBaseViewController {
    
    @IBOutlet weak var myTextView: UITextView!
    var index: Int = -1
    var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackBarButton()
        setSaveBarButton()
        // Do any additional setup after loading the view.
        myTextView.layer.cornerRadius = 5
        myTextView.layer.borderColor = rgba(0.91, 0.91, 0.92, 1.0).cgColor
        myTextView.layer.borderWidth = 1
        
        if index != -1 {
            myTextView.text = content
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if myTextView.isFirstResponder {
            myTextView.resignFirstResponder()
        }
    }
    
    override func saveAction(sender: UIBarButtonItem) {
        super.saveAction(sender: sender)
        if myTextView.text.characters.count == 0 {
            self.present(showAlert(title: "提示", msg: "请输入内容", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else {
            if index == -1 {
                if WJCommonContentManager.shared.addCommonContent(content: myTextView.text) {
                    _ = navigationController?.popViewController(animated: true)
                }
            }
            else {
                if WJCommonContentManager.shared.updateCommonContent(index: index, content: myTextView.text) {
                    _ = navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
