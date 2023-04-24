import UIKit

@available(iOS 11.0, *)
class TimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var weekofDay: Int = 0
    var routineArray: [Routine] = []
    let tableView = UITableView(frame: .zero, style: .grouped)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineArray = ViewController.routineArray.filter { routine in
            return routine.dayOfWeek == self.weekofDay
        }
        
        routineArray = routineArray.sorted(by: { $0.startTime < $1.startTime })
        
        // 设置tableView的代理和数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册自定义的cell
        tableView.register(RoutineTimelineCell.self, forCellReuseIdentifier: "RoutineTimelineCell")
        
        // 添加tableView到当前视图
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
            // 一个task为一个section
            return routineArray.count
        }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 每个section有4行
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTimelineCell", for: indexPath) as! RoutineTimelineCell
        
        let routine = routineArray[indexPath.section]
        switch indexPath.row {
        case 0:
            // 第一行为task1
            cell.textLabel?.text = "Task \(indexPath.section+1)"
        case 1:
            // 第二行为"名称："+routine的名称
            cell.textLabel?.text = "Task Name：\(routine.routineName)"
        case 2:
            // 第三行为"开始时间： "+开始时间
            cell.textLabel?.text = "Start： \(convertToTimeFormat(routine.startTime))"
        case 3:
            // 第四行为"结束时间： "+结束时间
            cell.textLabel?.text = "End： \(convertToTimeFormat(routine.endTime))"
        default:
            break
        }
        
        return cell
    }
    func convertToTimeFormat(_ num: Double) -> String {
        let hour = Int(num)
        let minute = Int((num - Double(hour)) * 60.0)
        return String(format: "%d:%02d", hour, minute)
    }

}

    class RoutineTimelineCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            // 修改label位置和高度
            textLabel?.frame = CGRect(x: 20, y: 0, width: frame.width - 40, height: frame.height)
            textLabel?.numberOfLines = 0
            textLabel?.lineBreakMode = .byWordWrapping
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

