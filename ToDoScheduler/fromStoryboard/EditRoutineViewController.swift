//
//  EditRoutineViewController.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit
protocol EditRoutineViewControllerDelegate {
    func didEditRoutine(routine:Routine,tag:Int)
    func didDeleteRoutine(routine:Routine,tag:Int)
}

class EditRoutineViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var routine:Routine?
    var layView:UIView?
    var weekNum:[Int]!
    var delegate:EditRoutineViewControllerDelegate?
    var routineTag:Int!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var routineNameTF: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var dayOfWeekPicker: UIPickerView!
    @IBOutlet weak var routineNumLabel: UILabel!
    
    let weekdays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置开始和结束时间选择器只显示整点和半点
        startTimePicker.minuteInterval = 30
        startTimePicker.datePickerMode = .time
        endTimePicker.minuteInterval = 30
        endTimePicker.datePickerMode = .time
        
        // 设置日期选择器的数据源和委托
        dayOfWeekPicker.dataSource = self
        dayOfWeekPicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRoutineInfo()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // 获取用户输入的日程名称
        guard let name = routineNameTF.text else {
            // 如果没有输入日程名称，则弹出提示框
            showAlert(title: "Tips", message: "Please type in the task name")
            return
        }
        
        // 获取用户选择的开始时间和结束时间
        let startTime = getTimeValue(from: startTimePicker.date)
        let endTime = getTimeValue(from: endTimePicker.date)
        
        // 获取用户选择的日期
        let dayOfWeek = dayOfWeekPicker.selectedRow(inComponent: 0) + 1
        
        self.routine?.startTime = startTime
        self.routine?.endTime = endTime
        self.routine?.dayOfWeek = dayOfWeek
        self.routine?.routineName = name
        
        self.delegate?.didEditRoutine(routine: self.routine!,tag: routineTag)
        
        
        // 返回上一级界面
        navigationController?.popViewController(animated: true)
    }
    
    // 将 UIDatePicker 中的时间转换成 double 类型的值
    private func getTimeValue(from date: Date) -> Double {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        return hour + (minute / 60)
    }
    
    // 显示提示框
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - 自定义方法
    func loadRoutineInfo(){
        if let routine = routine {
            self.routineNameTF.text = routine.routineName
            self.routineNumLabel.text = "Week \(String(describing: routine.dayOfWeek)) From \(String(describing: convertToTimeFormat(routine.startTime))) To \(String(describing: convertToTimeFormat(routine.endTime)))"
            self.title = "Eidt"
        }
    }
    
    func convertToTimeFormat(_ num: Double) -> String {
        let hour = Int(num)
        let minute = Int((num - Double(hour)) * 60.0)
        return String(format: "%d:%02d", hour, minute)
    }

    @IBAction func deleteRoutine(sender: AnyObject) {
        
        confirmDelete()
    }
        
    func confirmDelete(){
        let alertController = UIAlertController(title: "Delet Tip", message: "Delete?", preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "yes", style: .destructive) { (action) in
            self.delegate?.didDeleteRoutine(routine: self.routine!, tag: self.routineTag)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancleAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // UIPickerViewDataSource 和 UIPickerViewDelegate 协议方法
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weekdays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weekdays[row]
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

