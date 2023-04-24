//
//  Routine.swift
//  EasySchedule
//
//  Created by 包娟 on 2023/4/9.
//  Copyright © 2023 包娟. All rights reserved.
//

import UIKit

class Routine: Equatable {
    var taskid: Int
    var routineName: String
    var startTime: Double
    var endTime: Double
    var dayOfWeek: Int
    var weekOfMonth: Int
    var weekdayOfMonth: Int
    var month: Int
    var year: Int
    
    init(segmentstruct: Segmentstruct) {
        self.taskid = segmentstruct.taskId
        self.routineName = "class"
        self.dayOfWeek = 0
        self.startTime = 0.0
        self.endTime = 0.0
        self.weekOfMonth = 0
        self.weekdayOfMonth = 0
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        self.month = Calendar.current.component(.month, from: dateformatter.date(from:segmentstruct.day)!)
        self.year = Calendar.current.component(.year, from: dateformatter.date(from:segmentstruct.day)!)
//        if let routineName = taskid2name(segmentstruct.taskId){
//            self.routineName = routineName
//        } else{
//            self.routineName = "Not Found!"
//        }
        if let (start, end) = convertToTimeRange(startTime: segmentstruct.startTime, endTime: segmentstruct.endTime) {
            self.startTime = start
            self.endTime = end
        }
        if let weekday = isDateInThisWeek(dateformatter.date(from:segmentstruct.day)!) {
            self.dayOfWeek = weekday
        } else {
            self.dayOfWeek = 0
        }
        (self.weekOfMonth, self.weekdayOfMonth) = DayinMonth(dateformatter.date(from:segmentstruct.day)!)!
        
    }

        
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.routineName == rhs.routineName
    }

    func convertToHourMinute(_ timeIndex: Int) -> Double {
        let hour = Double(timeIndex / 2)
        let minute = Double((timeIndex % 2) * 30)
        return hour + (minute / 60)
    }

    func convertToTimeRange(startTime: Int, endTime: Int) -> (Double, Double)? {
        guard startTime <= endTime else {
            return nil // startTime shouldn't be after endTime
        }
        guard endTime <= 48 else {
            return nil // endTime is not a valid time index
        }
        let start = convertToHourMinute(startTime)
        let end = convertToHourMinute(endTime) + 0.5
        return (start, end)
    }
    
    func isDateInThisWeek(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let today = Date()
        
        // 获取今天所在的周的第一天
        var startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))
        // 如果当前日期在这个周的第一天之前，则在上一周，重新计算 startOfWeek
        if date < startOfWeek! {
            startOfWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: startOfWeek!)
        }
        
        // 获取这一周的最后一天
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek!)
        
        // 判断日期是否在这一周内，并返回星期几
        if date >= startOfWeek! && date <= endOfWeek! {
            let weekday = calendar.component(.weekday, from: date)
            return weekday
        } else {
            return nil
        }
    }
    
    func DayinMonth(_ date: Date)-> (Int, Int)?{
        let calendar = Calendar.current
        let weekOfMonth = calendar.component(.weekOfMonth, from: date) // 获取所在月的第几周
        let weekdayOfMonth = calendar.component(.weekday, from: date) // 获取星期几
        return (weekOfMonth, weekdayOfMonth)
    }
    
    func taskid2name(_ id:Int)->String?{
        let tasklist:[Taskstruct]=load("tasklistData.json")
        let index = id
        if index < tasklist.count {
            let task_name = tasklist[index].taskname
            return task_name
        } else {
            return nil
        }
    }
    
    func convert2segtime(_ startTime: Double, _ endTime: Double) -> (Int,Int)?{
        
        let starthour = Int(startTime)
        let startmin = Int((startTime - Double(starthour)) * 60)
        let starttime = String(format: "%02d:%02d", starthour, startmin)
        let endhour = Int(endTime)
        let endmin = Int((endTime - Double(endhour)) * 60)
        let endtime = String(format: "%02d:%02d", endhour, endmin)
        // 将起始时间和结束时间转换为分钟数
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let startIndex = starthour*2+startmin/30
        let endIndex = starthour*2+startmin/30+1
        
        return (startIndex, endIndex)
    }
    
    func dateOfWeekday(_ weekday: Int) -> Date? {
        let calendar = Calendar.current
        let today = Date()
        let weekdayIndex = calendar.component(.weekday, from: today) // 获取今天是星期几
        let offset = (weekday - weekdayIndex + 7) % 7 // 计算今天到目标星期的天数差距
        let targetDate = calendar.date(byAdding: .day, value: offset-6, to: today) // 计算目标日期
        return targetDate
    }

    func saveseglist(taskid: Int, startTime: Double, endTime: Double, dayOfWeek: Int) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        var seg = ViewController.segmentlist[taskid]
        (seg.startTime,seg.endTime) = convert2segtime(startTime, endTime)!
        seg.day = dateformatter.string(from: dateOfWeekday(dayOfWeek)!)
        
        ViewController.segmentlist[taskid] = seg
    }
    
    func deletseg(){
        let seg = ViewController.segmentlist[self.taskid]
        ViewController.segmentlist.remove(at: self.taskid)
    }


}

