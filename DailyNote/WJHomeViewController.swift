//
//  WJHomeViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/10/30.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJHomeViewController: WJBaseViewController {

    @IBOutlet weak var datePickerViewBgView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var myTableView: UITableView!
    var viewModel: WJHomeViewModel?
    private var dateStr: String = ""
    private var date = Date() {
        didSet {
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd"
            dateStr = formatter.string(from: date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        date = Date()
        setNavTitleButton(dateStr)
        
        datePickerView.date = date
        datePickerView.layer.backgroundColor = rgba(1.0, 1.0, 1.0, 0.5).cgColor
        datePickerView.maximumDate = Date()
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateData), for: .valueChanged)
        myTableView.addSubview(refresh)
        
        viewModel = WJHomeViewModel()
        viewModel?.reloadData = { [weak self] in
            refresh.endRefreshing()
            self?.myTableView.reloadData()
            self?.stopLoading()
        }
        
        myTableView.tableFooterView = UIView()
        myTableView.register(UINib.init(nibName: "WJNoteItemTableViewCell", bundle: nil), forCellReuseIdentifier: "WJNoteItemTableViewCell")
        myTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func updateData() {
        startLoading()
        viewModel?.queryNoteList(date: date)
    }
    
    override func titleButtonAction(sender: UIButton) {
        super.titleButtonAction(sender: sender)
        if datePickerView.alpha == 1 {
            hideDatePickerView(true)
            viewModel?.queryNoteList(date: date)
        }
        else {
            hideDatePickerView(false)
            datePickerView.setDate(date, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.dataSource.removeAll()
        viewModel?.queryNoteList(date: date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !kUserDefault.bool(forKey: kIsLogin) {
            showLoginView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingAction(_ sender: UIBarButtonItem) {
        let settingVC = WJSettingViewController(nibName: "WJSettingViewController", bundle: nil)
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @IBAction func addNoteAction(_ sender: UIBarButtonItem) {
        let addNoteItemVC = WJAddNoteItemViewController(nibName: "WJAddNoteItemViewController", bundle: nil)
        addNoteItemVC.date = date
        navigationController?.pushViewController(addNoteItemVC, animated: true)
    }
    
    @IBAction func datePickerViewAction(_ sender: UIDatePicker) {
        date = sender.date
        titleButton?.setTitle(dateStr, for: .normal)
    }
    
    @IBAction func datePickerViewBgViewTapAction(_ sender: UITapGestureRecognizer) {
        if datePickerView.alpha == 1 {
            hideDatePickerView(true)
            viewModel?.queryNoteList(date: date)
        }
        else {
            hideDatePickerView(false)
            datePickerView.setDate(date, animated: true)
        }
    }
    func hideDatePickerView(_ isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.datePickerView.alpha = 0
                self?.datePickerView.transform = CGAffineTransform.init(translationX: 0, y: 0)
                self?.datePickerViewBgView.alpha = 0
            })
        }
        else {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.datePickerView.alpha = 1
                self?.datePickerView.transform = CGAffineTransform.init(translationX: 0, y: -150)
                self?.datePickerViewBgView.alpha = 1
            })
        }
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension WJHomeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.dataSource.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WJNoteItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WJNoteItemTableViewCell") as! WJNoteItemTableViewCell
        cell.model = viewModel?.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.delectNoteItem(index: indexPath.row)
            viewModel?.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let count = viewModel?.dataSource.count, count > 0 {
            return 200
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let pieChartView = WJPieChartView()
        pieChartView.dataSource = (viewModel?.statisticData)!
        pieChartView.totalTimeLength = (viewModel?.totalTimeLength)!
        pieChartView.frame = CGRect(x:0, y:0, width: kScreenWidth, height: 200)
        pieChartView.reloadData()
        return pieChartView
    }
}

