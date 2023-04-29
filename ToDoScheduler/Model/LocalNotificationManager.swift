//
//  LocalNotificationManager.swift
//  ToDoScheduler
//
//  Created by 包娟 on 2023/4/30.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    private let center = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private let calendar = Calendar.current


    // Method to register for Notifications on the Device
    private func registerNotifications() {
        center.requestAuthorization(options: options) { granted, error in
            if granted && error == nil {
                print("Notifications are registered")
            } else {
                print("D'oh.. Notifications aren't registered")
            }
        }
    }
    
    func convert2date(startTime: Int, startdate: String) -> Date?{
        let start = convert2time(timeIndex: startTime)
        
        // 创建日期格式化器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 解析日期字符串为 Date 对象
        let date = dateFormatter.date(from: startdate)
        
        // 创建时间格式化器
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm" // 输入的时间格式

        // 解析开始时间和结束时间字符串为 Time 对象
        let sTime = timeFormatter.date(from: start)
        
        // 创建日历和日期组件
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date!)

        // 添加开始时间的小时和分钟到日期组件
        let startTimeComponents = calendar.dateComponents([.hour, .minute], from: sTime!)
        dateComponents.hour = startTimeComponents.hour
        dateComponents.minute = startTimeComponents.minute
        
        // 构建 startDate
        let startDate = calendar.date(from: dateComponents)

        return startDate
    }
    
    func convert2time(timeIndex: Int) -> String{
        let hour = Int(timeIndex / 2)
        let minute = Int((timeIndex % 2) * 30)
        let timeString = String(format: "%02d:%02d", hour, minute)
        return timeString
    }
    
    // Public Method used to schedule for Notifications
    func scheduleNotificationForEvent(segmentlist:[Segmentstruct], tasklist:[Taskstruct]) {
        
        self.registerNotifications()
        for segment in segmentlist{
            let startTime = convert2date(startTime: segment.startTime, startdate: segment.day)
            let newDate = calendar.date(byAdding: .minute, value: -10, to: startTime!)
            // 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = "Notice"
            content.body = "You have task '\(tasklist[segment.taskId].taskname)' to do"
            content.categoryIdentifier = "notificationCategory"
            
            // 创建通知触发器，设置为在事件前十分钟触发
            let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: newDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            // 创建通知请求
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // 添加通知请求到用户通知中心
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("无法添加通知请求: \(error.localizedDescription)")
                } else {
                    print("通知请求已添加")
                }
            }
        }
    }
}
