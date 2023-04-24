//
//  Daystruct.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/17.
//

import Foundation

struct Daystruct: Hashable, Codable, Identifiable{
    var id: Int
    var date: String
    
    var timeSlot: [Bool] = [Bool](repeating: false, count: 48)  // all available time, in half hour
    var schedule: [Bool] = [Bool](repeating: false, count: 48)  // occupied time, in half hour
    var segmentsId: [Int] = []                                  // the day's segments
}
