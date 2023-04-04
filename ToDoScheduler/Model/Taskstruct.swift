//
//  Taskstruct.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct Taskstruct: Identifiable{
    var id: Int
    var taskname: String
    var deadline: Date
    var estimatedCost: Int
    var importance: Int
    var description: String
    
    var segments: [Segmentstruct]
}
