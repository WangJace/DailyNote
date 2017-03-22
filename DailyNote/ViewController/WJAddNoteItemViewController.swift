//
//  WJAddNoteItemViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2016/11/8.
//  Copyright © 2016年 WangJace. All rights reserved.
//

import UIKit

class WJAddNoteItemViewController: WJBaseViewController {

    @IBOutlet weak var datePickerViewBgView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var noteTypeCollectionView: UICollectionView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var commonContentCollectionView: UICollectionView!
    @IBOutlet weak var myPickerView: WJPopupDatePickerView!
    @IBOutlet weak var popupPickerViewBottomSpace: NSLayoutConstraint!
    internal var viewModel:WJAddNoteItemViewModel?
    internal var noteTypeSelectedIndex = 0
    internal var commonContentSelectedIndex = -1
    internal let dateFormatter = DateFormatter()
    var date = Date()
    
    var noteTypeLayout: UICollectionViewFlowLayout?
    var commonContentLayout: UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackBarButton()
        setSaveBarButton()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        setNavTitleButton(dateFormatter.string(from: date))
        datePickerView.date = date
        datePickerView.layer.backgroundColor = rgba(1.0, 1.0, 1.0, 0.5).cgColor
        datePickerView.maximumDate = Date()
        
        viewModel = WJAddNoteItemViewModel()
        viewModel?.addSuccess = { [weak self] isSuccess in
            if isSuccess {
                self?.stopLoading()
                _ = self?.navigationController?.popViewController(animated: true)
            }
            else {
                self?.present(showAlert(title: "提示", msg: "出错，请再试一次", confirmText: "确定"), animated: true, completion: {
                    
                })
            }
        }
        
        myPickerView.cancelButtonClosure = { [weak self] in
            UIView.animate(withDuration: 1) {
                self?.myPickerView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            self?.isTimePickerViewHidden(true)
        }
        
        myPickerView.confirmButtonClosure = { [weak self] (startTime,endTime) in
            self?.viewModel?.model.startTime = startTime.timeIntervalSince1970
            self?.viewModel?.model.endTime = endTime.timeIntervalSince1970
            UIView.animate(withDuration: 1) {
                self?.myPickerView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self?.timeButton.setTitle("\(formatter.string(from: startTime))-\(formatter.string(from: endTime))", for: .normal)
            self?.isTimePickerViewHidden(true)
        }
        
        contentTextView.backgroundColor = WJNoteTypeManager.shared.getColor(nil)
    }
    
    override func titleButtonAction(sender: UIButton) {
        super.titleButtonAction(sender: sender)
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
        
        if datePickerView.alpha == 1 {
            hideDatePickerView(true)
        }
        else {
            hideDatePickerView(false)
            datePickerView.setDate(date, animated: true)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if noteTypeLayout == nil {
            //  设置 layout
            noteTypeLayout = UICollectionViewFlowLayout()
            noteTypeLayout?.scrollDirection = .horizontal  //滚动方向
            
            noteTypeCollectionView.delegate = self
            noteTypeCollectionView.dataSource = self
            noteTypeCollectionView.register(UINib.init(nibName: "WJNoteTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WJNoteTypeCollectionViewCell")
            noteTypeCollectionView.setCollectionViewLayout(noteTypeLayout!, animated: true)
        }
        
        if commonContentLayout == nil {
            //  设置 layout
            commonContentLayout = UICollectionViewFlowLayout()
            commonContentLayout?.scrollDirection = .horizontal  //滚动方向
            
            commonContentCollectionView.delegate = self
            commonContentCollectionView.dataSource = self
            commonContentCollectionView.register(UINib.init(nibName: "WJCommonContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WJCommonContentCollectionViewCell")
            commonContentCollectionView.setCollectionViewLayout(commonContentLayout!, animated: true)
        }
    }
    
    override func saveAction(sender: UIBarButtonItem) {
        super.saveAction(sender: sender)
        if timeButton.titleLabel?.text == "时间" {
            self.present(showAlert(title: "提示", msg: "还未设置时间", confirmText: "确定"), animated: true, completion: { 
                
            })
        }
        else if contentTextView.text.characters.count == 0 {
            self.present(showAlert(title: "提示", msg: "没有内容", confirmText: "确定"), animated: true, completion: {
                
            })
        }
        else {
            startLoading()
            viewModel?.model.typeId = WJNoteTypeManager.shared.noteTypes[noteTypeSelectedIndex].typeId
            viewModel?.model.date = date.getDateTimeInteral()
            viewModel?.model.content = contentTextView.text
            viewModel?.model.calculateTimeLength()
            viewModel?.addNoteItem()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func timeButtonAction(_ sender: UIButton) {
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        myPickerView.startTime = Date.init(timeIntervalSince1970: (viewModel?.model.startTime)!)
        myPickerView.endTime = Date.init(timeIntervalSince1970: (viewModel?.model.endTime)!)
        myPickerView.reloadData()
        UIView.animate(withDuration: 1) { 
            self.myPickerView.transform = CGAffineTransform(translationX: 0, y: -262)
        }
        isTimePickerViewHidden(false)
    }

    @IBAction func datePickerViewAction(_ sender: UIDatePicker) {
        date = sender.date
        titleButton?.setTitle(dateFormatter.string(from: date), for: .normal)
    }
    
    @IBAction func datePickerViewBgViewTapAction(_ sender: UITapGestureRecognizer) {
        if datePickerView.alpha == 1 {
            hideDatePickerView(true)
        }
        else {
            hideDatePickerView(false)
            datePickerView.setDate(date, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
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
        timeButton.isEnabled = isHidden
        contentTextView.isEditable = isHidden
        noteTypeCollectionView.isUserInteractionEnabled = isHidden
    }
    
    func isTimePickerViewHidden(_ isHidden: Bool) {
        titleButton?.isEnabled = isHidden
        contentTextView.isEditable = isHidden
        noteTypeCollectionView.isUserInteractionEnabled = isHidden
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

extension WJAddNoteItemViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1001 {
            return WJNoteTypeManager.shared.noteTypes.count
        }
        else {
            return WJCommonContentManager.shared.commontContents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1001 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WJNoteTypeCollectionViewCell", for: indexPath) as! WJNoteTypeCollectionViewCell
            cell.model = WJNoteTypeManager.shared.noteTypes[indexPath.row]
            if indexPath.row == noteTypeSelectedIndex {
                cell.isMark = true
            }
            else {
                cell.isMark = false
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WJCommonContentCollectionViewCell", for: indexPath) as! WJCommonContentCollectionViewCell
            cell.contentLabel.text = WJCommonContentManager.shared.commontContents[indexPath.row]
            if indexPath.row == commonContentSelectedIndex {
                cell.isMark = true
            }
            else {
                cell.isMark = false
            }
            return cell
        }
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1001 {
            if noteTypeSelectedIndex != indexPath.row {
                let preIndex = noteTypeSelectedIndex
                noteTypeSelectedIndex = indexPath.row
                collectionView.reloadItems(at: [indexPath,IndexPath.init(row: preIndex, section: 0)])
                contentTextView.backgroundColor = WJNoteTypeManager.shared.noteTypes[noteTypeSelectedIndex].getColor()
            }
        }
        else {
            if commonContentSelectedIndex != indexPath.row {
                let preIndex = commonContentSelectedIndex
                commonContentSelectedIndex = indexPath.row
                if preIndex != -1 {
                    collectionView.reloadItems(at: [indexPath, IndexPath.init(row: preIndex, section: 0)])
                }
                else {
                    collectionView.reloadItems(at: [indexPath])
                }
                contentTextView.text = WJCommonContentManager.shared.commontContents[commonContentSelectedIndex]
            }
        }
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView.tag == 1001 {
            return UIEdgeInsetsMake(10, 10, 10, 10)
        }
        else {
            return UIEdgeInsetsMake(0, 10, 0, 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1001 {
            return CGSize(width: 80, height: 80)
        }
        else {
            return CGSize(width: kScreenWidth/2-10, height: collectionView.frame.height)
        }
    }
}
