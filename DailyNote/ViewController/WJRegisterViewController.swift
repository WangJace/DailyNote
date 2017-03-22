//
//  WJRegisterViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/10/30.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJRegisterViewController: WJBaseViewController,WJTitleTextFieldDelegate {

    @IBOutlet weak var userNameTextField: WJTitleTextField!
    @IBOutlet weak var pwdTextField: WJTitleTextField!
    @IBOutlet weak var confirmTextField: WJTitleTextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        userNameTextField.delegate = self
        pwdTextField.delegate = self
        confirmTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if userNameTextField.text == "" {
            self.present(showAlert(title: "提示", msg: "请输入用户名", confirmText: "确定"), animated: true, completion: { 
                
            })
        }
        else if pwdTextField.text == "" {
            self.present(showAlert(title: "提示", msg: "请输入密码", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else if confirmTextField.text == "" {
            self.present(showAlert(title: "提示", msg: "请确认密码", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else if pwdTextField.text != confirmTextField.text {
            self.present(showAlert(title: "提示", msg: "密码不一致，请重新输入", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else {
            startLoading()
            let user = BmobObject.init(className: "_User")
            user?.setObject(userNameTextField.text, forKey: "username")
            user?.setObject(pwdTextField.text.MD5, forKey: "password")
            user?.saveInBackground(resultBlock: { [weak self] (isSuccessful, error) in
                self?.stopLoading()
                if isSuccessful {
                    self?.dismiss(animated: true, completion: { 
                        
                    })
                }
                else {
                    self?.present(showAlert(title: "提示", msg: "注册失败，请再试一次", confirmText: "确定"), animated: true, completion: { 
                        
                    })
                }
            })
        }
    }
    
    // MARK: - WJTitleTextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userNameTextField.myTextField.isFirstResponder {
            userNameTextField.myTextField.resignFirstResponder()
        }
        else if pwdTextField.myTextField.isFirstResponder {
            pwdTextField.myTextField.resignFirstResponder()
        }
        else if confirmTextField.myTextField.isFirstResponder {
            confirmTextField.myTextField.resignFirstResponder()
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
