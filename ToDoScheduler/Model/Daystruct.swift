//
//  Daystruct.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/17.
//

import Foundation

struct Daystruct: Hashable, Codable, Identifiable{
    var id = UUID()
    var date: String = ""
    var periodEmpty = [Bool](repeating: true, count: 6)  // day's empty slots
    
    var schedule = [Segmentstruct](repeating: Segmentstruct(), count: 6)
}
