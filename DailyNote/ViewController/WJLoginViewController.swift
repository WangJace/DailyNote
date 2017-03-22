//
//  WJLoginViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/10/30.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJLoginViewController: WJBaseViewController,WJTitleTextFieldDelegate {

    @IBOutlet weak var userNameTextField: WJTitleTextField!
    @IBOutlet weak var pwdTextField: WJTitleTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userNameTextField.delegate = self
        pwdTextField.delegate = self
        
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 8
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderWidth = 1
        
        navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        if userNameTextField.text == "" {
            self.present(showAlert(title: "提示", msg: "请输入用户名", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else if pwdTextField.text == "" {
            self.present(showAlert(title: "提示", msg: "请输入密码", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else {
            startLoading()
            let query = BmobQuery.init(className: "_User")
            let conditions = [["username":userNameTextField.text], ["password":pwdTextField.text.MD5]]
            query?.addTheConstraintByAndOperation(with: conditions)
            query?.findObjectsInBackground({ [weak self] (arr, error) in
                self?.stopLoading()
                if let count = arr?.count, count > 0 {
                    let obj = arr?.first as! BmobObject
                    kUserDefault.set(true, forKey: kIsLogin)
                    kUserDefault.set(self?.userNameTextField.text, forKey: kUserName)
                    kUserDefault.set(self?.pwdTextField.text.MD5, forKey: kPwd)
                    kUserDefault.set(obj.objectId, forKey: kUserId)
                    self?.updateNoteTypeList()
                    self?.dismiss(animated: true, completion: {
                        
                    })
                }
                else  {
                    self?.present(showAlert(title: "提示", msg: "用户名或者密码错误，请重新输入", confirmText: "确定"), animated: true, completion: {
                        
                    })
                }
            })
        }
    }

    @IBAction func registerAction(_ sender: UIButton) {
        let registerVC = WJRegisterViewController(nibName:"WJRegisterViewController", bundle:nil)
        navigationController?.pushViewController(registerVC, animated: true)
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
    }
    
    func updateNoteTypeList() {
        DispatchQueue.global().async {
            let query = BmobQuery.init(className: "NoteType")
            let conditions = [["userId":kUserDefault.object(forKey: kUserId)]]
            query?.addTheConstraintByAndOperation(with: conditions)
            
            query?.findObjectsInBackground({ (arr, error) in
                if let count = arr?.count, count > 0 {
                    var noteTypes = [[String:String]]()
                    let temp = arr as! [BmobObject]
                    for obj:BmobObject in temp {
                        let name = obj.object(forKey: "name") as! String
                        let color = obj.object(forKey: "color") as! String
                        let dic:[String:String] = ["id":obj.objectId, "name":name, "color":color]
                        noteTypes.append(dic)
                    }
                    let flag = WJNoteTypeManager.shared.localizableNoteTypeList(noteTypes)
                    print(flag)
                }
                else {
                    let temp = [["name":"学习","color":"#836874"],["name":"工作","color":"#EEDFA4"],["name":"娱乐","color":"#F2B33F"],["name":"运动","color":"#CF5555"],["name":"其他","color":"#9288B1"]]
                    for dic in temp {
                        let noteType:BmobObject = BmobObject(className: "NoteType")
                        noteType.setObject(kUserDefault.object(forKey: kUserId), forKey: "userId")
                        noteType.setObject(dic["name"], forKey: "name")
                        noteType.setObject(dic["color"], forKey: "color")
                        noteType.saveInBackground(resultBlock: { [weak noteType] (isSuceess, error) in
                            if error != nil{
                                //发生错误后的动作
                                print("error is \(error?.localizedDescription)")
                            }else{
                                //创建成功后会返回objectId，updatedAt，createdAt等信息
                                //创建对象成功，打印对象值
                                if let type = noteType {
                                    let name = type.object(forKey: "name") as! String
                                    let color = type.object(forKey: "color") as! String
                                    let flag = WJNoteTypeManager.shared.localizableNoteType(["id":type.objectId, "name":name, "color":color])
                                    print(flag)
                                }
                            }
                        })
                    }
                }
            })
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
