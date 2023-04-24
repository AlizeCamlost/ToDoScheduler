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
//
//
//    @IBOutlet weak var weekCV: UICollectionView!
//    @IBOutlet weak var mainCV: UICollectionView!
    var showCount = 0
    var weekItems = [ "Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
    var currentSelected:IndexPath?
    var imageView = UIImageView()
    
    var routineCellSize:CGSize!
    var frame = CGRect(x: 0,y: 0,width: 0,height: 0)
    
    let routineColor = UIColor(red: 74/255, green: 187/255, blue: 230/255, alpha: 1)
   
    
    static var segmentlist:[Segmentstruct]=[]
    
    static var ItemSlot:Int = 0
    
    static var routineArray = [Routine]()



    static var routineLabelArray = [UILabel]()
    
    lazy var editVC:EditRoutineViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditRoutineViewController") as! EditRoutineViewController
        vc.delegate = self
        return  vc
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        let bgImageView = UIImageView(frame: self.view.frame)
//        bgImageView.image = UIImage(named: "bg")
//        self.view.insertSubview(bgImageView, belowSubview: weekCV)
//
//        weekCV.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
//        mainCV.register(UINib(nibName: "WeekDayCell", bundle: nil), forCellWithReuseIdentifier: "WeekDayCell")
//        mainCV.register(UINib(nibName: "RoutineCell", bundle: nil), forCellWithReuseIdentifier: "RoutineCell")
//
//        weekCV.alpha = 0.5
//        mainCV.alpha = 0.5
//        if #available(iOS 11.0, *) {
//            weekCV.contentInsetAdjustmentBehavior = .never
//            mainCV.contentInsetAdjustmentBehavior = .never
//        } else {
//            automaticallyAdjustsScrollViewInsets = false
//        }
//
//        // 找到UICollectionView的高度约束
//        if let heightConstraint = mainCV.constraints.first(where: { $0.firstAttribute == .height }) {
//            // 更新约束的常量值
//            heightConstraint.constant = SCREEN_HEIGHT - 250
//            // 应用更改
//            view.layoutIfNeeded()
//        }

//        segmentlist=load("segmentlistData.json")
        ViewController.segmentlist.removeAll()
        //let isoDate = "2023-04-27T00:00:00+0800"
        let isoDate = "2023-04-27"
//        let formatter = ISO8601DateFormatter()
//        let date = formatter.date(from: isoDate)
        var segment = Segmentstruct(id: 0, taskId: 0, day: "2023-04-26")
        segment.taskId=0
        segment.day = isoDate
        segment.startTime = 9
        segment.endTime=17
        ViewController.segmentlist.append(segment)
//
//        mainCV.reloadData()

//        loadRoutine()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewController.routineArray.removeAll()
        ViewController.routineArray=ViewController.segmentlist.map { segment in
            Routine(segmentstruct: segment)
        }
        
        clearRoutineLabels()
        
        drawRoutine(routineArray: ViewController.routineArray)
        
//        if showCount == 0{
//            for routineItem in self.routineArray {
//
//            }
//            self.showCount += 1
//        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func editRoutine(_ recognizer:UITapGestureRecognizer) {
        
        let label = recognizer.view as! UILabel
        editVC.routine = ViewController.routineArray[label.tag]
        editVC.routineTag = label.tag
        self.navigationController?.pushViewController(editVC, animated: true)

    }
    
    private func clearRoutineLabels() {
        
        for label in ViewController.routineLabelArray {
            let routineView = label.superview
            routineView?.removeFromSuperview()
        }
        ViewController.routineLabelArray.removeAll()
    }

    func drawRoutine(routineArray:Array<Routine>){
        let columheight = 4 * routineCellSize.height
        for i in 0..<7 {
            
            let matchingRoutines = routineArray.filter { $0.dayOfWeek == i + 1 && $0.dayOfWeek != 0 }

            let startX = CGFloat(30) + CGFloat(i) * routineCellSize.width

            for matchingRoutine in matchingRoutines {
                let start = matchingRoutine.startTime
                let end = matchingRoutine.endTime
                let duration = end - start
                let ratio = duration / 24.0
                let startY = CGFloat(130)  + columheight * start / 24.0
                self.frame = CGRect(x: startX, y: startY, width: routineCellSize.width, height: columheight*CGFloat(ratio))
                let routineView = UIView(frame: frame)
//                self.view.insertSubview(routineView, aboveSubview: self.mainCV)
                self.view.insertSubview(routineView, aboveSubview: self.view.subviews.last ?? UIView())
                let routineInfoLabel = UILabel(frame: CGRectMake(0,2,routineView.frame.size.width-2,routineView.frame.size.height-2))
                routineInfoLabel.numberOfLines = 5
                routineInfoLabel.font = UIFont.systemFont(ofSize: 12)
                routineInfoLabel.textAlignment = .left
                routineInfoLabel.textColor = UIColor.white
                routineInfoLabel.text = "\(String(describing: matchingRoutine.routineName))"
                routineInfoLabel.tag = ViewController.routineArray.firstIndex(of: matchingRoutine)!
                routineInfoLabel.layer.cornerRadius = 5
                routineInfoLabel.layer.masksToBounds = true
                routineInfoLabel.backgroundColor = routineColor
                routineView.addSubview(routineInfoLabel)
                ViewController.routineLabelArray.append(routineInfoLabel)
                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(editRoutine(_:)))
//                    routineInfoLabel.addGestureRecognizer(tap)
//                    routineInfoLabel.isUserInteractionEnabled = true
            }
        }
    }
    
    func didEditRoutine(routine: Routine,tag:Int) {
//        let routineView = self.routineLabelArray[tag].superview
//        routineView?.removeFromSuperview()
        let routineLabel = ViewController.routineLabelArray[tag]
        routineLabel.text = "\(String(describing: routine.routineName))"
        routine.saveseglist(taskid: routine.taskid, startTime: routine.startTime, endTime: routine.endTime, dayOfWeek: routine.dayOfWeek)
//        saveRoutine()
    }
    
    func didDeleteRoutine(routine:Routine,tag:Int){
        let routineView = ViewController.routineLabelArray[tag].superview
        routineView?.removeFromSuperview()
        ViewController.routineLabelArray.remove(at:tag)
//        saveRoutine()
    }
    
}

//extension ViewController: UICollectionViewDataSource{
//    //MARK: - UICollectionViewDataSource
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
////        var number = 0
////        if collectionView == self.weekCV{
////            number = 1
////        }else if collectionView == self.mainCV {
////            number = 1
////        }
////        return number
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.weekCV {
//            return weekItems.count + 1
//        }else if collectionView == self.mainCV {
//            return ( (self.weekItems.count+1) * 4 )
//        }
//        return 0
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//        if collectionView == self.weekCV {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath as IndexPath) as! WeekDayCell
//
////            if indexPath.row == 0 {
////                cell.dayLabel.text = ""
////            }else{
////                cell.dayLabel.text = self.weekItems[indexPath.row-1]
////
////            }
//
//            cell.dayLabel.text = indexPath.row == 0 ? ""  :  self.weekItems[indexPath.row-1]
//
//            return cell
//
//        }else {
//            if indexPath.row % 8 == 0 {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDayCell", for: indexPath as IndexPath) as! WeekDayCell
//                cell.dayLabel.text = "\(indexPath.row / (self.weekItems.count + 1) + 1)"
//
//                return cell
//            }else{
//                let routineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoutineCell", for: indexPath as IndexPath) as! RoutineCell
//                routineCell.routineLabel.text = ""
//                return routineCell
//            }
//
//        }
//
//
//
//    }
//
//}
//
//extension ViewController: UICollectionViewDelegateFlowLayout{
//    //MARK: - UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.weekCV {
//            if (indexPath.row == 0) {
//                return CGSize(width: 30, height: 30)
//            } else {
//                return CGSize(width: (SCREEN_WIDTH - 30) / 7, height: 30)
//            }
//        } else if collectionView == self.mainCV {
//            let rowHeight = CGFloat((SCREEN_HEIGHT - 250) / 4)
//            if (indexPath.row % 8 == 0) {
//                return CGSize(width: 30, height: rowHeight)
//            } else {
//                self.routineCellSize = CGSize(width: (SCREEN_WIDTH - 30) / 7, height: rowHeight)
//                return self.routineCellSize
//            }
//        }
//        return CGSize(width: 0, height: 0)
//    }
//
//}
//
//@available(iOS 11.0, *)
//extension ViewController: UICollectionViewDelegate{
//    //MARK: - UICollectionViewDelegate
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == self.weekCV && (indexPath.row != 0){
//            let TL:TimeLineViewController = {
//                let TL = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeLineViewController") as! TimeLineViewController
//                return  TL
//            }()
//            TL.weekofDay = indexPath.row
//            self.navigationController?.pushViewController(TL, animated: true)
//        }
//    }
//
//}

