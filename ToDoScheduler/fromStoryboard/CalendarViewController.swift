
import UIKit

//MARK:- Protocol
protocol ViewLogic {
    var numberOfWeeks: Int { get set }
    var daysArray: [String]! { get set }
}

//MARK:- UIViewController
class CalendarViewController: UIViewController, ViewLogic {
    
    //MARK: Properties
    var numberOfWeeks: Int = 0
    var daysArray: [String]!
    var frame = CGRect(x: 0,y: 0,width: 0,height: 0)
    let routineColor = UIColor(red: 74/255, green: 187/255, blue: 230/255, alpha: 1)
    let weekWidth = 59
    let weekHeight = 59
    let dayWidth = 59
    let dayHeight = 100
    private var requestForCalendar: RequestForCalendar?
    
    private let date = DateItems.ThisMonth.Request()
    private let daysPerWeek = 7
    private var thisYear: Int = 0
    private var thisMonth: Int = 0
    private var today: Int = 0
    private var isToday = true
    private let dayOfWeekLabel = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
    private var monthCounter = 0
    static var routineLabelArray = [UILabel]()
    
    //MARK: UI Parts
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func prevBtn(_ sender: UIBarButtonItem) { prevMonth() }
    @IBAction func nextBtn(_ sender: UIBarButtonItem) { nextMonth() }
    
    @IBOutlet weak var mbtn: UIButton!
    @IBAction func WeekView(_ sender: Any) {
        let Wview:ViewController = {
            let Wview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
            return Wview
        }()
        self.navigationController?.pushViewController(Wview, animated: true)
    }
    //MARK: Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dependencyInjection()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dependencyInjection()
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        settingLabel()
        getToday()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        clearRoutineLabels()
        
        drawRoutine(routineArray: ViewController.routineArray,year: Int(date.year),month: Int(date.month))
        
    }
    
    //MARK: Setting
    private func dependencyInjection() {
        let viewController = self
        let calendarController = CalendarController()
        let calendarPresenter = CalendarPresenter()
        let calendarUseCase = CalendarUseCase()
        viewController.requestForCalendar = calendarController
        calendarController.calendarLogic = calendarUseCase
        calendarUseCase.responseForCalendar = calendarPresenter
        calendarPresenter.viewLogic = viewController
    }
    
    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        requestForCalendar?.requestNumberOfWeeks(request: date)
        requestForCalendar?.requestDateManager(request: date)
    }
    
    private func settingLabel() {
        mbtn.setTitle( "\(String(date.year))/\(String(date.month))",for: .normal )
    }
    
    private func getToday() {
        thisYear = date.year
        thisMonth = date.month
        today = date.day
    }

}

//MARK:- Setting Button Items
extension CalendarViewController {
    
    private func nextMonth() {
        monthCounter += 1
        commonSettingMoveMonth()
    }
    
    private func prevMonth() {
        monthCounter -= 1
        commonSettingMoveMonth()
    }
    
    private func commonSettingMoveMonth() {
        daysArray = nil
        let moveDate = DateItems.MoveMonth.Request(monthCounter)
        requestForCalendar?.requestNumberOfWeeks(request: moveDate)
        requestForCalendar?.requestDateManager(request: moveDate)
        mbtn.setTitle( "\(String(moveDate.year))/\(String(moveDate.month))",for: .normal )
        isToday = thisYear == moveDate.year && thisMonth == moveDate.month ? true : false
        collectionView.reloadData()
        clearRoutineLabels()
        drawRoutine(routineArray: ViewController.routineArray,year: Int(moveDate.year),month: Int(moveDate.month))
    }
    
    func clearRoutineLabels() {
        
        for label in CalendarViewController.routineLabelArray {
            let routineView = label.superview
            routineView?.removeFromSuperview()
        }
        CalendarViewController.routineLabelArray.removeAll()
    }
    
    func drawRoutine(routineArray:Array<Routine>, year: Int, month: Int){
        let matchingRs = routineArray.filter { $0.month == month && $0.year == year }
        var i = 0
        for j in 1..<8 {
            if j == 7{
                i = 0
            } else {
                i = j
            }
            for w in 1..<6{
                let matchingRoutines = matchingRs.filter{$0.weekdayOfMonth == i && $0.weekOfMonth == w}
                let startX = CGFloat(i-1) * CGFloat(dayWidth-4)
                var startY = CGFloat(20) + CGFloat(weekHeight-60)  + CGFloat((w+1)*dayHeight)
                for matchingRoutine in matchingRoutines {
                    self.frame = CGRect(x: startX, y: startY, width: CGFloat(dayWidth), height: CGFloat(dayHeight)/6)
                    startY = startY + CGFloat(dayHeight/6)
                    let routineView = UIView(frame: frame)
                    self.view.insertSubview(routineView, aboveSubview: self.view.subviews.last ?? UIView())
                    
                    let routineInfoLabel = UILabel(frame: CGRectMake(0,2,routineView.frame.size.width-10,routineView.frame.size.height-2))
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
                    CalendarViewController.routineLabelArray.append(routineInfoLabel)
                }
            }
        }
    }
    
    
}

//MARK:- UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 7 : (numberOfWeeks * daysPerWeek)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
    
        if indexPath.section == 0{
            label.textAlignment = .center
            label.numberOfLines = 0 // 允许多行
            label.frame = CGRect(x: 0, y: 0, width: 200, height: 200) // 假设 label 的大小为 200x200
            label.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2) // 将 label 居中
            label.textAlignment = .center
        }else{
            label.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.width / 3, height: cell.contentView.frame.height / 3)
            label.textAlignment = .left // 设置 label 的文本对齐方式为左对齐

        }
        
        
        label.backgroundColor = .clear

        dayOfWeekColor(label, indexPath.row, daysPerWeek)
        showDate(indexPath.section, indexPath.row, cell, label)
        return cell
    }

    
    private func dayOfWeekColor(_ label: UILabel, _ row: Int, _ daysPerWeek: Int) {
        switch row % daysPerWeek {
        case 0: label.textColor = .red
        case 6: label.textColor = .blue
        default: label.textColor = .black
        }
    }
    
    private func showDate(_ section: Int, _ row: Int, _ cell: UICollectionViewCell, _ label: UILabel) {
        switch section {
        case 0:
            label.text = dayOfWeekLabel[row]
            cell.selectedBackgroundView = nil
        default:
            label.text = daysArray[row]
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            cell.selectedBackgroundView = selectedView
            markToday(label)
        }
    }
    
    private func markToday(_ label: UILabel) {
        if isToday, today.description == label.text {
            label.backgroundColor = UIColor.init(red: 240/255, green: 150/255, blue: 122/255, alpha: 0.3)
        }
    }
    
}

//MARK:- UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let weekWidth = Int(collectionView.frame.width) / daysPerWeek
        let weekHeight = weekWidth
        let dayWidth = weekWidth
        let dayHeight = (Int(collectionView.frame.height) - weekHeight) / numberOfWeeks
        return indexPath.section == 0 ? CGSize(width: weekWidth, height: weekHeight) : CGSize(width: dayWidth, height: dayHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let surplus = Int(collectionView.frame.width) % daysPerWeek
        let margin = CGFloat(surplus)/2.0
        return UIEdgeInsets(top: 0.0, left: margin, bottom: 1.5, right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    
}

