//
//  RoutineCell.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit

//class RoutineCell: UICollectionViewCell,  UITableViewDataSource, UITableViewDelegate{
class RoutineCell: UICollectionViewCell{
    @IBOutlet weak var routineLabel: UILabel!
//    var tableView: UITableView!
//    var data: [String]?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        tableView = UITableView(frame: contentView.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        contentView.addSubview(tableView)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//
//        // 创建 table view，并添加到 cell 的 contentView 中
//        tableView = UITableView(frame: contentView.bounds, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        contentView.addSubview(tableView)
//    }
//
//    // UITableViewDataSource
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 12
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data?[indexPath.row]
//        return cell
//    }
//
//    // UITableViewDelegate
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 处理 cell 选中事件
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
