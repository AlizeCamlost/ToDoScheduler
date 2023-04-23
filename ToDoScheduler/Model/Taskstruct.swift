//
//  Taskstruct.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct Taskstruct: Hashable, Codable, Identifiable{
    var id = UUID()
    var taskname: String
    var deadline: Date
    var estimatedCost: Int              // in half hours
    var granularity: Int = 2            // four levels(temporary), 1: half hour, 2: one hour, 4:two hours, 8: four hours
    var schedulePrefernece: Int = 1     // three tpyes(tmeporary), 1: as soon as possible, 2: averagely, 3: as late as possible
    //var importance: Int
    var description: String = ""
    
    var segmentsId: [Int] = []
}
