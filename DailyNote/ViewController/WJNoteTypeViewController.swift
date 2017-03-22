//
//  WJNoteTypeViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/1/7.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

enum WJNoteTypeViewControllerType {
    case Add, Edit
}

class WJNoteTypeViewController: WJBaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var myCollectionView: UICollectionView!
    internal var viewModel: WJNoteTypeViewModel = WJNoteTypeViewModel()
    internal var selectedIndex: Int = 0
    var type: WJNoteTypeViewControllerType = .Add
    var model: WJNoteItemType? {
        didSet {
            navigationItem.title = model?.name
            if let color = model?.color {
                for i in 0..<viewModel.colorArr.count {
                    if color == viewModel.colorArr[i] {
                        selectedIndex = i
                        break
                    }
                }
            }
        }
    }
    
    var layout:UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomBackBarButton()
        setSaveBarButton()
        // Do any additional setup after loading the view.
        nameTextField.text = model?.name
        
        myCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func saveAction(sender: UIBarButtonItem) {
        super.saveAction(sender: sender)
        
        if let count = nameTextField.text?.characters.count, count == 0 {
            self.present(showAlert(title: "提示", msg: "请输入类型名称", confirmText: "确定"), animated: true, completion: { 
                
            })
        }
        else {
            let color = viewModel.colorArr[selectedIndex]
            let name = nameTextField.text!
            model?.name = name
            model?.color = color
            if type == .Add {
                let noteType:BmobObject = BmobObject(className: "NoteType")
                noteType.setObject(kUserDefault.object(forKey: kUserId), forKey: "userId")
                noteType.setObject(name, forKey: "name")
                noteType.setObject(color, forKey: "color")
                noteType.saveInBackground(resultBlock: { [weak noteType, weak self] (isSuccessful, error) in
                    if error != nil{
                        //发生错误后的动作
                        print("error is \(error?.localizedDescription)")
                    }else{
                        //创建成功后会返回objectId，updatedAt，createdAt等信息
                        //创建对象成功，打印对象值
                        if let typeId = noteType?.objectId {
                            let dic:[String:String] = ["id":typeId, "name":name, "color":color]
                            _ = WJNoteTypeManager.shared.localizableNoteType(dic)
                        }
                        _ = self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
            else {
                let noteType:BmobObject = BmobObject(className: "NoteType")
                noteType.setObject(kUserDefault.object(forKey: kUserId), forKey: "userId")
                noteType.setObject(name, forKey: "name")
                noteType.setObject(color, forKey: "color")
                noteType.objectId = model?.typeId
                noteType.updateInBackground(resultBlock: { [weak noteType, weak self](isSuccessful, error) in
                    if error != nil{
                        //发生错误后的动作
                        print("error is \(error?.localizedDescription)")
                    }else{
                        //创建成功后会返回objectId，updatedAt，createdAt等信息
                        //创建对象成功，打印对象值
                        if let typeId = noteType?.objectId {
                            let dic:[String:String] = ["id":typeId, "name":name, "color":color]
                            _ = WJNoteTypeManager.shared.updateLocalizableNoteType(dic)
                        }
                        _ = self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if layout == nil {
            //  设置 layout
            layout = UICollectionViewFlowLayout()
            layout?.scrollDirection = .vertical  //滚动方向
            
            myCollectionView.delegate = self
            myCollectionView.dataSource = self
            myCollectionView.register(UINib.init(nibName: "WJNoteTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WJNoteTypeCollectionViewCell")
            myCollectionView.setCollectionViewLayout(layout!, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
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

extension WJNoteTypeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colorArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WJNoteTypeCollectionViewCell", for: indexPath) as! WJNoteTypeCollectionViewCell
        cell.color = viewModel.colorArr[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.isMark = true
        }
        else {
            cell.isMark = false
        }
        return cell
    }
    
    //MARK:UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row {
            let preIndex = selectedIndex
            selectedIndex = indexPath.row
            collectionView.reloadItems(at: [indexPath,IndexPath.init(row: preIndex, section: 0)])
        }
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:80, height:80)
    }
}
