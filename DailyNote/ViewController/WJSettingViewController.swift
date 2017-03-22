//
//  WJSettingViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/8.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJSettingViewController: WJBaseViewController {

    let cellIdentifier = "settingCell"
    @IBOutlet weak var myTableView: UITableView!
    
    let dataSource = [kUserDefault.value(forKey: kUserName),"日记类型", "常用日记内容", "退出"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "设置"
        setCustomBackBarButton()
        myTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: - UITableViewDataSource,UITableViewDelegate
extension WJSettingViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = dataSource[indexPath.section] as! String?
        if indexPath.section == dataSource.count-1 {
            cell?.textLabel?.textAlignment = .center
            cell?.accessoryType = .none
        }
        else {
            cell?.textLabel?.textAlignment = .left
            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == dataSource.count-1 {
            return kScreenHeight - CGFloat((dataSource.count-1)*200)
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            break
        case 1:
            let noteTypeManagerVC = WJNoteTypeManagerViewController(nibName: "WJNoteTypeManagerViewController", bundle: nil)
            navigationController?.pushViewController(noteTypeManagerVC, animated: true)
        case 2:
            let commonContentVC = WJCommonContentViewController(nibName: "WJCommonContentViewController", bundle: nil)
            navigationController?.pushViewController(commonContentVC, animated: true)
        case 3:
            showLoginView()
            _ = navigationController?.popToRootViewController(animated: true)
        default:
            break
        }
    }
}
