//
//  ViewController.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let ArchiveURL = documentsDirectory.appendingPathComponent("routines")


class ViewController: UIViewController,EditRoutineViewControllerDelegate {
    
    @IBOutlet weak var weekCV: UICollectionView!
    @IBOutlet weak var mainCV: UICollectionView!
    var showCount = 0
    var weekItems = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    var currentSelected:IndexPath?
    var imageView = UIImageView()
    
    var routineCellSize:CGSize!
    
    let routineColor = UIColor(red: 74/255, green: 187/255, blue: 230/255, alpha: 1)
    static var ItemSlot:Int = 0
    
    var routineArray = [Routine]()
    var routineLabelArray = [UILabel]()
    
    lazy var editVC:EditRoutineViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditRoutineViewController") as! EditRoutineViewController
        vc.delegate = self
        return  vc
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let bgImageView = UIImageView(frame: self.view.frame)
        bgImageView.image = UIImage(named: "bg")
        self.view.insertSubview(bgImageView, belowSubview: weekCV)
        
        weekCV.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        mainCV.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
        mainCV.register(UINib(nibName: "RoutineCell", bundle: nil), forCellWithReuseIdentifier: "RoutineCell")
        
        weekCV.alpha = 0.5
        mainCV.alpha = 0.5
        if #available(iOS 11.0, *) {
            weekCV.contentInsetAdjustmentBehavior = .never
            mainCV.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        // 找到UICollectionView的高度约束
        if let heightConstraint = mainCV.constraints.first(where: { $0.firstAttribute == .height }) {
            // 更新约束的常量值
            heightConstraint.constant = SCREEN_HEIGHT - 250
            // 应用更改
            view.layoutIfNeeded()
        }

        mainCV.reloadData()
//        loadRoutine()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawRoutine(routineArray: routineArray)
//        if showCount == 0{
//            for routineItem in self.routineArray {
//
//            }
//            self.showCount += 1
//        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
   
    
    //MARK: - 自定义方法
    
    @objc func addRoutine(){
        let selectedCell = self.mainCV.cellForItem(at: currentSelected! as IndexPath)
        self.imageView.removeFromSuperview()
        selectedCell?.contentView.backgroundColor = UIColor.clear
        currentSelected = nil
        let addRoutineVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditRoutineViewController") as! EditRoutineViewController
        addRoutineVC.delegate = self

        self.navigationController?.pushViewController(addRoutineVC, animated: true)
    }
    
    @objc func editRoutine(_ recognizer:UITapGestureRecognizer) {
        let label = recognizer.view as! UILabel
        editVC.stateTag = 1
        editVC.routine = self.routineArray[label.tag]
        editVC.routineTag = label.tag
        self.navigationController?.pushViewController(editVC, animated: true)

    }
    func drawRoutine(routineArray:Array<Routine>){
//        let rowNum = routine.end - routine.start + 1
//        let width = routineCellSize.width
//        let height = routineCellSize.height * CGFloat(rowNum)
//        let x = CGFloat(30) + CGFloat(routine.day - 1 ) * routineCellSize.width
//        let y = CGFloat(30 + 64) + CGFloat(routine.start - 1) * routineCellSize.height
//        let routineView = UIView(frame: CGRectMake(x, y, width, height))
//        routineView.backgroundColor = routineColor
//        routineView.alpha = 0.8
//        self.view.insertSubview(routineView, aboveSubview: self.mainCV)
//
//        let routineInfoLabel = UILabel(frame: CGRectMake(0,2,routineView.frame.size.width-2,routineView.frame.size.height-2))
//        routineInfoLabel.numberOfLines = 5
//        routineInfoLabel.font = UIFont.systemFont(ofSize: 12)
//        routineInfoLabel.textAlignment = .left
//        routineInfoLabel.textColor = UIColor.white
//        routineInfoLabel.text = "\(String(describing: routine.routineName)))"
//        routineInfoLabel.tag = self.routineArray.firstIndex(of: routine)!
//        routineInfoLabel.layer.cornerRadius = 5
//        routineInfoLabel.layer.masksToBounds = true
//        routineInfoLabel.backgroundColor = routineColor
//        routineView.addSubview(routineInfoLabel)
//
//        self.routineLabelArray.append(routineInfoLabel)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.editRoutine(_:)))
//
//        routineInfoLabel.addGestureRecognizer(tap)
//        routineInfoLabel.isUserInteractionEnabled = true

//        let startTimes: [Double] = [0.0, 6.0, 12.0, 18.0] // 每个时间段的起始时间
        for i in 0..<7 {
            for j in 1...4 {
                let matchingRoutines = routineArray.filter { $0.day == i + 1 && $0.slot == j }
                let startX = CGFloat(30) + CGFloat(i) * routineCellSize.width
                var startY = CGFloat(30 + 64) + CGFloat(j - 1) * routineCellSize.height
                for matchingRoutine in matchingRoutines {
//                    // 处理匹配到的 `matchingRoutine`
//                    let start = matchingRoutine.starttime - startTimes[routine.slot - 1]
//                    let end = matchingRoutine.endtime - startTimes[routine.slot - 1]
//
//                    // 计算在该时间段中的占比
//                    let duration = end - start
//                    let ratio = duration / 6.0
//
//                    // 计算在课程表中的长度和起始位置
//                    let cellWidth = routineCellSize.width
//                    let cellHeight = routineCellSize.height
//                    let startX = CGFloat(i) * cellWidth
//                    let startY = CGFloat(j - 1) * cellHeight + cellHeight * start / 6.0
//                    let width = cellWidth
//                    let height = cellHeight * CGFloat(ratio)
//                    let frame = CGRect(x: startX, y: startY, width: width, height: height)
                    let frame = CGRect(x: startX, y: startY, width: routineCellSize.width, height: routineCellSize.height/6)
                    startY = startY + routineCellSize.height/12
                    let routineView = UIView(frame: frame)
                    self.view.insertSubview(routineView, aboveSubview: self.mainCV)
                    let routineInfoLabel = UILabel(frame: CGRectMake(0,2,routineView.frame.size.width-2,routineView.frame.size.height-2))
                    routineInfoLabel.numberOfLines = 5
                    routineInfoLabel.font = UIFont.systemFont(ofSize: 12)
                    routineInfoLabel.textAlignment = .left
                    routineInfoLabel.textColor = UIColor.white
                    routineInfoLabel.text = "\(String(describing: matchingRoutine.routineName)))"
                    routineInfoLabel.tag = self.routineArray.firstIndex(of: matchingRoutine)!
                    routineInfoLabel.layer.cornerRadius = 5
                    routineInfoLabel.layer.masksToBounds = true
                    routineInfoLabel.backgroundColor = routineColor
                    routineView.addSubview(routineInfoLabel)
                    self.routineLabelArray.append(routineInfoLabel)
                }
            }
        }
        
    }
    
    
    //MARK: - EditRoutineViewControllerDelegate
    func didSetRoutine(routine: Routine) {
        routineArray.append(routine)
//        saveRoutine()
        drawRoutine(routineArray: routineArray)
        
        
    }
    func didEditRoutine(routine: Routine,tag:Int) {
        self.routineArray[tag] = routine
//        saveRoutine()
        let routineLabel = self.routineLabelArray[tag]
        routineLabel.text = "\(String(describing: routine.routineName))"
        self.routineArray[tag] = routine
//        saveRoutine()
    }
    
    func didDeleteRoutine(routine:Routine,tag:Int){
        let routineView = self.routineLabelArray[tag].superview
        routineView?.removeFromSuperview()
        self.routineArray.remove(at:tag)
        self.routineLabelArray.remove(at:tag)
//        saveRoutine()
    }
    
    
    //MARK: - 数据持久化
//    func saveRoutine() {
//        let data = NSMutableData()
//
//        //申明一个归档处理对象
//        let archiver = NSKeyedArchiver.init(requiringSecureCoding: false)
//        //将lists以对应Checklist关键字进行编码
//        archiver.encode(self.routineArray, forKey: "routines")
//        //编码结束
//        archiver.finishEncoding()
//        //数据写入
//        data.write(toFile: ArchiveURL.path, atomically: true)
//    }
    
//    func loadRoutine(){
//        //获取本地数据文件地址
//        let path = ArchiveURL.path
//        //声明文件管理器
//        let defaultManager = FileManager()
//
//        //通过文件地址判断数据文件是否存在
//        if defaultManager.fileExists(atPath: path) {
//            //读取文件数据
//            let data = NSData(contentsOfFile: path)
//            do {
//                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data! as Data)
//                //通过归档时设置的关键字Checklist还原lists
//                self.routineArray = unarchiver.decodeObject(forKey: "routines") as! Array
//                //结束解码
//                unarchiver.finishDecoding()
//            } catch {
//                // 处理解档错误
//                print(error)
//            }
//            for item in routineArray {
//                print(item.routineName)
//            }
//        }

//    }

    
    
        
}
extension ViewController: UICollectionViewDataSource{
    //MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var number = 0
        if collectionView == self.weekCV{
            number = 1
        }else if collectionView == self.mainCV {
            number = 1
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.weekCV {
            return weekItems.count + 1
        }else if collectionView == self.mainCV {
            return ( (self.weekItems.count+1) * 4 )
        }
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.weekCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath as IndexPath) as! WeekDayCell

            if indexPath.row == 0 {
                cell.dayLabel.text = ""
            }else{
                cell.dayLabel.text = self.weekItems[indexPath.row-1]
                
            }
            return cell

        }else {
            if indexPath.row % 8 == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath as IndexPath) as! WeekDayCell
                cell.dayLabel.text = "\(indexPath.row / (self.weekItems.count + 1) + 1)"
                return cell
            }else{
                let routineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutineCell", for: indexPath as IndexPath) as! RoutineCell
                routineCell.routineLabel.text = ""
                return routineCell
            }

        }
        
        
        
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout{
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.weekCV {
            if (indexPath.row == 0) {
                return CGSize(width: 30, height: 30)
            } else {
                return CGSize(width: (SCREEN_WIDTH - 30) / 7, height: 30)
            }
        } else if collectionView == self.mainCV {
            let rowHeight = CGFloat((SCREEN_HEIGHT - 250) / 4)
            if (indexPath.row % 8 == 0) {
                return CGSize(width: 30, height: rowHeight)
            } else {
                self.routineCellSize = CGSize(width: (SCREEN_WIDTH - 30) / 7, height: rowHeight)
                return self.routineCellSize
            }
        }
        return CGSize(width: 0, height: 0)
    }
    
}

extension ViewController: UICollectionViewDelegate{
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.mainCV && indexPath.row % (self.weekItems.count + 1) == 0 {
            var cell: WeekDayCell?
            self.currentSelected = indexPath
            cell = collectionView.cellForItem(at: currentSelected!) as? WeekDayCell
            DetailScheduler.timeslot = indexPath.row / 8 + 1
//            cell?.contentView.backgroundColor = UIColor.lightGray
            let detailVC:DetailScheduler = {
                let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScheduler") as! DetailScheduler
                return  dvc
            }()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if collectionView == self.mainCV && indexPath.row % (self.weekItems.count + 1) == 0 {
//            var cell: WeekDayCell?
//            cell = collectionView.cellForItem(at: indexPath as IndexPath) as? WeekDayCell
//            cell?.contentView.backgroundColor = UIColor.clear
//            collectionView.deselectItem(at: indexPath, animated: true)
//        }
//    }

}
