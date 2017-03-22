//
//  WJTitleTextField.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/10/30.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit
import SnapKit

@IBDesignable

class WJTitleTextField: UIView {
    // MARK: 属性
    @IBInspectable var title: String? { didSet { titleLabel.text = title } }
    @IBInspectable var placeholder: String? { didSet { myTextField.placeholder = placeholder } }
    @IBInspectable var titleColor: UIColor? { didSet { titleLabel.textColor = titleColor } }
    @IBInspectable var myTextFieldColor: UIColor? { didSet { myTextField.textColor = myTextFieldColor } }
    @IBInspectable var isSecureTextEntry: Bool = false { didSet { myTextField.isSecureTextEntry = isSecureTextEntry } }
    @IBInspectable var titleLabelWidth: CGFloat { didSet { setNeedsDisplay() } }
    
    var titleLabel: UILabel
    var myTextField: UITextField
    var delegate: WJTitleTextFieldDelegate? {
        didSet {
            myTextField.delegate = delegate
        }
    }
    var text: String {
        get {
            if let temp = myTextField.text {
                return temp
            }
            else {
                return ""
            }
        }
    }
    
    // MARK: 初始化方法
    override init(frame: CGRect) {
        titleLabel = UILabel()
        myTextField = UITextField()
        titleLabelWidth = 80
        super.init(frame: frame)
        setUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        titleLabel = UILabel()
        myTextField = UITextField()
        titleLabelWidth = 80
        
        super.init(coder:aDecoder)!
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(titleLabelWidth)
        }
        
        myTextField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(self.snp.right)
        }
    }
    
    private func setUI() {
        self.addSubview(titleLabel)
        self.addSubview(myTextField)
        titleLabel.textAlignment = .right
        myTextField.textAlignment = .left
        myTextField.borderStyle = .roundedRect
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

protocol WJTitleTextFieldDelegate: UITextFieldDelegate {}
