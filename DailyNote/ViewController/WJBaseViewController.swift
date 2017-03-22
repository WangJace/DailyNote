//
//  WJBaseViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/10/30.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit
import SnapKit

class WJBaseViewController: UIViewController {

    var titleButton: UIButton?
    var loadingView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = RGBA(240, 248, 245, 1.0)
        
    }
    
    override func viewWillLayoutSubviews() {
        if let temp = loadingView {
            temp.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }
        
        if let temp = activityIndicator {
            temp.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 40, height: 40))
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavTitleButton(_ title: String) {
        titleButton?.setTitle(title, for: .normal)
        titleButton = UIButton.init(type: .roundedRect)
        titleButton?.setTitle(title, for: .normal)
        titleButton?.addTarget(self, action: #selector(titleButtonAction(sender:)), for: .touchUpInside)
        titleButton?.setTitleColor(UIColor.darkGray, for: .normal)
        titleButton?.layer.masksToBounds = true
        titleButton?.layer.cornerRadius = 8
        titleButton?.backgroundColor = rgba(0.2, 0.2, 0.2, 0.2)
        titleButton?.frame = CGRect(x:0, y:7, width: 130, height: 30)
        navigationItem.titleView = titleButton
    }
    
    func titleButtonAction(sender: UIButton) {
        
    }
    
    func setCustomBackBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: .done, target: self, action: #selector(backAction(sender:)))
    }
    
    func backAction(sender: UIBarButtonItem) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        }
        else {
            dismiss(animated: true, completion: { 
                
            })
        }
    }
    
    func setSaveBarButton() {
        let barItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(saveAction(sender:)))
        barItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName:UIColor.darkGray], for: .normal)
        navigationItem.rightBarButtonItem = barItem
    }
    
    func saveAction(sender: UIBarButtonItem) {
        
    }
    
    func setAddBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "add"), style: .done, target: self, action: #selector(addAction(sender:)))
    }
    
    func addAction(sender: UIBarButtonItem) {
        
    }
    
    func showLoginView()  {
        kUserDefault.set(false, forKey: kIsLogin)
        kUserDefault.set("", forKey: kUserName)
        kUserDefault.set("", forKey: kPwd)
        kUserDefault.set("", forKey: kUserId)
        let loginVC = WJLoginViewController.init(nibName:"WJLoginViewController", bundle: nil)
        let loginNav = UINavigationController.init(rootViewController: loginVC)
        present(loginNav, animated: true, completion: {
            
        })
    }
    
    func startLoading() {
        if loadingView == nil {
            activityIndicator?.startAnimating()
            loadingView = UIView()
            loadingView?.backgroundColor = rgba(0.0, 0.0, 0.0, 0.5)
            loadingView?.alpha = 0
            view.addSubview(loadingView!)
            
            activityIndicator = UIActivityIndicatorView()
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.activityIndicatorViewStyle = .whiteLarge
            loadingView?.addSubview(activityIndicator!)
        }
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.loadingView?.alpha = 1
        }) { [weak self] (_) in
            self?.activityIndicator?.startAnimating()
        }
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.loadingView?.alpha = 0
        }) { [weak self] (_) in
            self?.activityIndicator?.stopAnimating()
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
