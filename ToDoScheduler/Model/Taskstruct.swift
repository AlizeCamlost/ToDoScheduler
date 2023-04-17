//
//  Taskstruct.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct Taskstruct: Hashable, Codable, Identifiable{
    var id = UUID()
    var taskname: String = ""
    var deadline: Date = Date()
    var estimatedCost: Int = 0
    //var importance: Int
    //var description: String
    
    var segmentsId: [Int] = []
}
