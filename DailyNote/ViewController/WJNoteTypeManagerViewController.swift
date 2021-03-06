//
//  WJNoteTypeManagerViewController.swift
//  DailyNote
//
//  Created by 王傲云 on 2017/1/5.
//  Copyright © 2017年 WangJace. All rights reserved.
//

import UIKit

enum AutoScrollType {
    case Down, Up
}

class WJNoteTypeManagerViewController: WJBaseViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    private var fromeIndexPath: IndexPath?
    private var toIndexPath: IndexPath?
    private var cellImageView: UIImageView?
    private var displayLink: CADisplayLink?
    private var autoScrollType: AutoScrollType = .Down
    private var scrollSpeed: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "日记类型"
        setCustomBackBarButton()
        setAddBarButton()
        // Do any additional setup after loading the view.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteTypeCell")
        myTableView.tableFooterView = UIView()
        myTableView.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    
    override func addAction(sender: UIBarButtonItem) {
        super.addAction(sender: sender)
        let noteTypeVC = WJNoteTypeViewController(nibName: "WJNoteTypeViewController", bundle: nil)
        noteTypeVC.type = .Add
        navigationController?.pushViewController(noteTypeVC, animated: true)
    }
    
    func longPressAction(_ sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: myTableView)
        switch sender.state {
        case .began:
            // 根据手势点击的位置，获取被点击cell所在的indexPath
            fromeIndexPath = myTableView.indexPathForRow(at: point)
            // 不一定能获取到indexPath，因为点击的位置可能是header或者footer
            guard let indexPath = fromeIndexPath else {
                return
            }
            // 根据indexPath获取cell
            guard let cell = myTableView.cellForRow(at: indexPath) else {
                return
            }
            // 创建一个imageView，imageView的image由cell渲染得来
            cellImageView = createCellImageView(cell)
            guard let imageView = cellImageView else {
                return
            }
            // 更改imageView的中心点为手指点击位置
            let center = cell.center
            imageView.center = center
            imageView.alpha = 0
            UIView.animate(withDuration: 0.25, animations: { 
                imageView.center = center;
                imageView.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
                imageView.alpha = 0.9
                cell.alpha = 0
            }, completion: { (isFinished) in
                // 隐藏要移动的cell
                cell.isHidden  = true
            })
        case .changed:
            toIndexPath = myTableView.indexPathForRow(at: point)
            if let imageView = cellImageView {
                // 1.更改imageView的中心点为手指点击位置
                var center = imageView.center
                center.y = point.y
                imageView.center = center
                
                // 2.判断cell是否被拖拽到了tableView的边缘，如果是，则自动滚动tableView
                if isScrollToEdge() {
                    startTimerToScrollTableView()
                }
                else {
                    displayLink?.invalidate()
                }
                
                // 3.如果是插入效果，实时改变所经过cell的位置
                if let indexPath1 = fromeIndexPath, let indexPath2 = toIndexPath, indexPath1 != indexPath2  {
                    if !isExchange() {
                        insertCell(indexPath2)
                    }
                }
            }
        case .ended:
            if isExchange() {
                exchangeCell(point)
            }
            displayLink?.invalidate()
            
            guard let indexPath = fromeIndexPath else {
                return
            }
            //将隐藏的cell显示出来，并将imageView移除掉
            let cell = myTableView.cellForRow(at: indexPath)
            cell?.isHidden = false
            cell?.alpha = 0
            UIView.animate(withDuration: 0.25, animations: { 
                cell?.alpha = 1
                self.cellImageView?.alpha = 0
                self.cellImageView?.transform = CGAffineTransform()
                self.cellImageView?.center = (cell?.center)!
            }, completion: { (isFinished) in
                self.cellImageView?.removeFromSuperview()
                self.cellImageView = nil
            })
        default:
            break
        }
    }
    
    func createCellImageView(_ cell: UITableViewCell) -> UIImageView? {
        //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
        UIGraphicsBeginImageContext(cell.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        cell.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imageView = UIImageView.init(image: image)
        imageView.layer.shadowOffset = CGSize(width: -5, height: 0)
        imageView.layer.shadowRadius = 5
        myTableView.addSubview(imageView)
        return imageView
    }
    
    func isScrollToEdge() -> Bool {
        guard let imageView = cellImageView else {
            return false
        }
        if (imageView.frame.maxY > myTableView.contentOffset.y + myTableView.frame.height - myTableView.contentInset.bottom) && (myTableView.contentOffset.y < myTableView.contentSize.height - myTableView.frame.height + myTableView.contentInset.bottom) {
            autoScrollType = .Down
            return true
        }
    
        if (imageView.frame.origin.y < myTableView.contentOffset.y + myTableView.contentInset.top) && (myTableView.contentOffset.y > myTableView.contentInset.top) {
            autoScrollType = .Up
            return true
        }
        
        return false
    }
    
    func startTimerToScrollTableView() {
        displayLink?.invalidate()
        displayLink = CADisplayLink.init(target: self, selector: #selector(scrollTableView))
        displayLink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    func isExchange() -> Bool {
        return false
    }
    
    func exchangeCell(_ point: CGPoint) {
        guard let indexPath = myTableView.indexPathForRow(at: point) else {
            return
        }
        
        //交换要移动cell与被替换cell的数据模型
        if let indexPath1 = fromeIndexPath {
            if WJNoteTypeManager.shared.moveNoteTypeListRow(indexPath1.row, to: indexPath.row) {
                self.myTableView.reloadData()
            }
        }
    }
    
    func insertCell(_ indexPath: IndexPath) {
        // 交换两个cell的数据模型
        
        if var indexPath1 = fromeIndexPath {
            if WJNoteTypeManager.shared.moveNoteTypeListRow(indexPath1.row, to: indexPath.row) {
                myTableView.reloadRows(at: [indexPath1, indexPath], with: .automatic)
                
                // 重新隐藏cell
                let cell = myTableView.cellForRow(at: indexPath)
                cell?.isHidden = true
                fromeIndexPath = indexPath
            }
        }
    }
    
    func scrollTableView() {
        //如果已经滚动到最上面或最下面，则停止定时器并返回
        if (autoScrollType == .Up && myTableView.contentOffset.y <= myTableView.contentInset.top) || (autoScrollType == .Down && myTableView.contentOffset.y >= myTableView.contentSize.height - myTableView.frame.height + myTableView.contentInset.bottom) {
            displayLink?.invalidate()
            return
        }
        
        guard let imageView = cellImageView else {
            return
        }
        //改变tableView的contentOffset，实现自动滚动
        let height = autoScrollType == .Up ? -scrollSpeed:scrollSpeed
        myTableView.contentOffset = CGPoint(x:0, y: myTableView.contentOffset.y + height)
        //改变cellImageView的位置为手指所在位置
        imageView.center = CGPoint(x: imageView.center.x, y: imageView.center.y + height)
        
        //滚动tableView的同时也要执行插入操作
        toIndexPath = myTableView.indexPathForRow(at: imageView.center)
        if let indexPath1 = fromeIndexPath, let indexPath2 = toIndexPath, indexPath1 != indexPath2 {
            if !isExchange() {
                insertCell(indexPath2)
            }
        }
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
extension WJNoteTypeManagerViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WJNoteTypeManager.shared.noteTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTypeCell")!
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = WJNoteTypeManager.shared.noteTypes[indexPath.row].name
        cell.backgroundColor = WJNoteTypeManager.shared.noteTypes[indexPath.row].getColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteTypeVC = WJNoteTypeViewController(nibName: "WJNoteTypeViewController", bundle: nil)
        noteTypeVC.model = WJNoteTypeManager.shared.noteTypes[indexPath.row]
        noteTypeVC.type = .Edit
        navigationController?.pushViewController(noteTypeVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let typeId = WJNoteTypeManager.shared.noteTypes[indexPath.row].typeId
            let query = BmobQuery.init(className: "Notes")
            let conditions = [["userId":kUserDefault.object(forKey: kUserId)], ["typeId":typeId]]
            query?.addTheConstraintByAndOperation(with: conditions)
            query?.findObjectsInBackground({ (arr, error) in
                if let count = arr?.count, count > 0 {
                    if let temp = arr {
                        _ = temp.map( {
                            let obj = $0 as! BmobObject
                            obj.deleteInBackground()
                        })
                    }
                }
            })
            let deleteNoteType = BmobObject.init(outDataWithClassName: "NoteType", objectId: typeId)
            deleteNoteType?.deleteInBackground({ (isSuccessful, error) in
                if (isSuccessful) {
                    //删除成功后的动作
                    print ("success");
                }else{
                    print("delete error \(error?.localizedDescription)")
                }
            })
            _ = WJNoteTypeManager.shared.deleteLocalizableNoteType(typeId)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
