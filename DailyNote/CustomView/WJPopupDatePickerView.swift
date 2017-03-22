//
//  WJPopupDatePickerView.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/13.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit
import SnapKit

class WJPopupDatePickerView: UIView {

    private let dateFormatter:DateFormatter = DateFormatter()
    var startTime: Date {
        didSet {
            startTimeButton.setTitle("从 \(dateFormatter.string(from: startTime))", for: .normal)
            datePickerView.setDate(startTime, animated: true)
        }
    }
    var endTime: Date {
        didSet {
            endTimeButton.setTitle("至 \(dateFormatter.string(from: endTime))", for: .normal)
        }
    }
    
    var confirmButtonClosure:((Date,Date)->Void)?
    var cancelButtonClosure:((Void)->Void)?
    
    internal let kDatePickerViewTextColor = rgba(0.42, 0.50, 0.53, 1.0)
    
    private var topView: UIView
    private var cancelButton: UIButton
    private var confirmButton: UIButton
    private var datePickerView: UIDatePicker
    internal var startTimeButton: UIButton
    internal var endTimeButton: UIButton
    internal var isChangeStartTime = true
    
    override init(frame: CGRect) {
        topView = UIView()
        cancelButton = UIButton.init(type: .roundedRect)
        confirmButton = UIButton.init(type: .roundedRect)
        datePickerView = UIDatePicker()
        startTimeButton = UIButton.init(type: .roundedRect)
        endTimeButton = UIButton.init(type: .roundedRect)
        startTime = Date()
        endTime = Date()
        super.init(frame: frame)
        dateFormatter.dateFormat = "HH:mm"
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        topView = UIView()
        cancelButton = UIButton.init(type: .roundedRect)
        confirmButton = UIButton.init(type: .roundedRect)
        datePickerView = UIDatePicker()
        startTimeButton = UIButton.init(type: .roundedRect)
        endTimeButton = UIButton.init(type: .roundedRect)
        startTime = Date()
        endTime = Date()
        super.init(coder: aDecoder)
        dateFormatter.dateFormat = "HH:mm"
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    private func setUI() {
        topView.backgroundColor = popUpPickerViewGrayBgColor(1.0)
        addSubview(topView)
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        cancelButton.setTitleColor(kDatePickerViewTextColor, for: .normal)
        topView.addSubview(cancelButton)
        
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmButton.setTitle("完成", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmAction(sender:)), for: .touchUpInside)
        confirmButton.setTitleColor(kDatePickerViewTextColor, for: .normal)
        topView.addSubview(confirmButton)
        
        startTimeButton.tag = 1001
        startTimeButton.setTitle("从", for: .normal)
        startTimeButton.addTarget(self, action: #selector(changePickerViewTarget(sender:)), for: .touchUpInside)
        startTimeButton.setTitleColor(kDatePickerViewTextColor, for: .normal)
        startTimeButton.backgroundColor = popUpPickerViewGrayBgColor(0.5)
        addSubview(startTimeButton)
        
        endTimeButton.tag = 1002
        endTimeButton.setTitle("至", for: .normal)
        endTimeButton.addTarget(self, action: #selector(changePickerViewTarget(sender:)), for: .touchUpInside)
        endTimeButton.setTitleColor(kDatePickerViewTextColor, for: .normal)
        endTimeButton.backgroundColor = UIColor.white
        addSubview(endTimeButton)
        
        datePickerView.datePickerMode = .time
        datePickerView.addTarget(self, action: #selector(datePickerViewValueChangedAction(_:)), for: .valueChanged)
        datePickerView.tintColor = kDatePickerViewTextColor
        datePickerView.setDate(startTime, animated: true)
        addSubview(datePickerView)
    }
    
    private func updateUI() {
        topView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(100)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.size.equalTo(cancelButton.snp.size)
            
        }
        
        startTimeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
        
        endTimeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(startTimeButton.snp.bottom)
            make.size.equalTo(startTimeButton.snp.size)
        }
        
        datePickerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(endTimeButton.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func cancelAction(sender: UIButton) {
        if cancelButtonClosure != nil {
            cancelButtonClosure!()
        }
    }
    
    func confirmAction(sender: UIButton) {
        if confirmButtonClosure != nil {
            
            confirmButtonClosure!(startTime,endTime)
        }
    }
    
    func datePickerViewValueChangedAction(_ sender: UIDatePicker) {
        if isChangeStartTime {
            startTime = sender.date
            startTimeButton.setTitle("从\(dateFormatter.string(from: startTime))", for: .normal)
        }
        else {
            endTime = sender.date
            endTimeButton.setTitle("至\(dateFormatter.string(from: endTime))", for: .normal)
        }
    }
    
    func changePickerViewTarget(sender: UIButton) {
        isChangeStartTime = sender.tag == 1001
        if sender.tag == 1001 {
            startTimeButton.backgroundColor = popUpPickerViewGrayBgColor(0.5)
            endTimeButton.backgroundColor = UIColor.white
            datePickerView.setDate(startTime, animated: true)
        }
        else {
            startTimeButton.backgroundColor = UIColor.white
            endTimeButton.backgroundColor = popUpPickerViewGrayBgColor(0.5)
            datePickerView.setDate(endTime, animated: true)
        }
    }
    
    func reloadData() {
        startTimeButton.backgroundColor = popUpPickerViewGrayBgColor(0.5)
        endTimeButton.backgroundColor = UIColor.white
        datePickerView.setDate(startTime, animated: true)
        
    }
    
    internal func popUpPickerViewGrayBgColor(_ alpha: CGFloat) -> UIColor {
       return rgba(0.85, 0.85, 0.85, alpha)
    }
}
