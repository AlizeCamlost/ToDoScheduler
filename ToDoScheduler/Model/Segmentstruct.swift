//
//  Segmentstruct.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct Segmentstruct: Hashable, Codable, Identifiable{
    var id = UUID()
    var taskId: Int
    var day: Date = Date()
    var startTime: Int = 0
    var endTime: Int = 0
}
