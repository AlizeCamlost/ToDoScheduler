//
//  EditRoutineViewController.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit
protocol EditRoutineViewControllerDelegate {
    func didSetRoutine(routine:Routine)
    func didEditRoutine(routine:Routine,tag:Int)
    func didDeleteRoutine(routine:Routine,tag:Int)
}

class EditRoutineViewController: UITableViewController,SetRoutineTimeViewControllerDelegate {
    var stateTag = 0 //0代表添加课程，1代表修改课程信息
    
    var routine:Routine?
    var layView:UIView?
    var timeInfo:[Int]!
    var weekNum:[Int]!
    var delegate:EditRoutineViewControllerDelegate?
    var routineTag:Int!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var routineNameTF: UITextField!
    @IBOutlet weak var routineNumLabel: UILabel!
    @IBOutlet weak var weekNumLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if stateTag == 0{
            self.routine = Routine()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRoutineInfo()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 自定义方法
    func loadRoutineInfo(){
        if stateTag == 1 {
            if let routine = routine {
                self.routineNameTF.text = routine.routineName
                self.routineNumLabel.text = "周\(String(describing: routine.day))从\(String(describing: routine.start))至\(String(describing: routine.end))"
                self.timeInfo = [routine.day,routine.start,routine.end]
                self.title = "修改日程信息"
            }
        }else{
            self.deleteBtn.isHidden = true
        }
    }

    @IBAction func deleteRoutine(sender: AnyObject) {
        
        confirmDelete()
    }
    
    @IBAction func doneBtnClicked(sender: AnyObject) {
        if routineNameTF.text?.isEmpty == false
        {
            //如果是添加课程则初始化一个新日程
            
            routine?.routineName = self.routineNameTF.text
            routine?.day = self.timeInfo[0]
            routine?.start = self.timeInfo[1]
            routine?.end = self.timeInfo[2]
            if self.stateTag == 0{
                self.delegate?.didSetRoutine(routine: self.routine!)
            }else{
                self.delegate?.didEditRoutine(routine: self.routine!,tag: routineTag)
            }
            
            self.navigationController?.popViewController(animated: true)
            
        }else{
            let alert = UIAlertController(title: "无法提交", message: "信息不能为空", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func confirmDelete(){
        let alertController = UIAlertController(title: "删除提示", message: "是否删除这个日程", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "删除", style: .destructive) { (action) in
            self.delegate?.didDeleteRoutine(routine: self.routine!, tag: self.routineTag)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancleAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    //MARK: - UITableViewDelegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.isSelected = false
//            switch indexPath.row {
//            case 0:
//                let picker = SetRoutineTimeViewController()
//                picker.delegate = self
//                self.present(picker, animated: true, completion: nil)
//                break
//            case 1:
//                let weekPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetWeekViewController") as! SetWeekViewController
//                weekPicker.delegate = self
//                weekPicker.modalPresentationStyle = .overCurrentContext
//                self.present(weekPicker, animated: true, completion: nil)
//                break
//            default:
//                break
//            }
//        }
//    }
    
    //MARK: - SetRoutineTimeViewControllerDelegate
    func getSelectedResult(result: [Int]!) {
        self.routineNumLabel.text = "周\(result[0])从\(result[1])至\(result[2])"
        self.timeInfo = result
    }
    //MARK: - SetWeekViewControllerDelegate
//    func didSetWeek(week: [Int]) {
//        self.weekNum = week
//        var weekNum = 0
//        for item in week {
//            if item == 1{
//                weekNum += 1
//            }
//        }
//        self.weekNumLabel.text = "共\(weekNum)周"
//    }
}
