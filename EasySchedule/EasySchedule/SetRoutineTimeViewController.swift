//
//  SetRoutineTimeViewController.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit

protocol SetRoutineTimeViewControllerDelegate {
    func getSelectedResult(result:[Int]!)
}

class SetRoutineTimeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    let weekDayArray = ["周一","周二","周三","周四","周五","周六","周日"]
    let startArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    let endArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    var pickerView:UIPickerView?
    
    var dataArray:[[String]] = []//数据源
    var columns = 3//列数
    var layView:UIView?
    
    var selectedResult:[Int]?
    
    var delegate:SetRoutineTimeViewControllerDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.clear
        // Initialize pickerView
        pickerView = UIPickerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-200, width: UIScreen.main.bounds.width, height: 200))
        pickerView?.backgroundColor = UIColor.white
        self.view.addSubview(pickerView!)
        pickerView?.dataSource = self
        pickerView?.delegate = self
        dataArray.append(weekDayArray)
        dataArray.append(startArray)
        dataArray.append(endArray)

        // Initialize picker toolbar
        let pickerToolbar = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - pickerView!.frame.size.height - 40, width: UIScreen.main.bounds.width, height: 40))
        if #available(iOS 13.0, *) {
            pickerToolbar.backgroundColor = UIColor.systemGroupedBackground
        } else {
            pickerToolbar.backgroundColor = UIColor.groupTableViewBackground
        }

        self.view.addSubview(pickerToolbar)
        let doneBtn = UIButton(type: .system)
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        doneBtn.frame = CGRect(x: pickerToolbar.frame.size.width - 50, y: 5, width: 40, height: 25)
        doneBtn.addTarget(self, action: #selector(self.doneBtnClicked), for: .touchUpInside)
        pickerToolbar.addSubview(doneBtn)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedResult = Array(repeating: 1, count: self.columns)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-240))
        layView?.backgroundColor = UIColor.black
        layView?.alpha = 0.2
        //为点击view添加tap动作
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.cancle))
        self.layView!.addGestureRecognizer(tap)
        self.layView!.isUserInteractionEnabled = true
        self.view.addSubview(layView!)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneBtnClicked() {
        if let delegate = self.delegate {
            delegate.getSelectedResult(result: self.selectedResult)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancle() {
        self.layView?.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIPickerViewDataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.dataArray[component].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return columns
    }
    
    //MARK: - UIPickerViewDelegate
    
    //每行的高度
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    //每列的宽度
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width / CGFloat( columns )
    }
    
    //自定义列的每行的视图即指定每行视图的行为一致
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if (view == nil) {
            self.view = UIView()
        }
        
        let label = UILabel(frame: CGRectMake(0,0,self.view.frame.width / CGFloat( columns ), 20 ))
        if component == 2 {
            label.text = "至" + (dataArray[component][row] as String )
        }else{
            label.text = dataArray[component][row] as String
        }
        label.textAlignment = .center
        view?.addSubview(label)
        return view!
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedResult![component] = row + 1
    }
    
    
    
    
}
