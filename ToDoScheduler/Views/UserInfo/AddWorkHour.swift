//
//  AddWorkHour.swift
//  ToDoScheduler
//
//  Created by Tiancheng Xu on 29/4/2023.
//

import SwiftUI

struct AddWorkHour: View {
    @EnvironmentObject var taskData: Tasks
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var startTime1 = Date()
    @State private var endTime1 = Date()
    @State private var testTime = Date()
    
    var daynum :Int
    @State var minterval: Int = 30
    @Environment(\.presentationMode) var presentationMode
    
    @State private var TimeStr = ""
    @State private var endTimeStr = ""
    @State private var hour = Int()
    @State private var min = Int()
    @State private var index = Int()
    @State private var showAdditionalPickers = false
    @State private var additionalStartDates: [Date] = []
    @State private var additionalEndDates: [Date] = []
    @State private var additionalDescription: [String] = []
    
    var dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    let df: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .short
        return dateformatter
    }()
    
    let df1: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "h:mm a"
        return dateformatter
    }()
        
    var body: some View {
        //display working hours
        let timeIntervals = getTimeIntervals()
        
        NavigationView(){

            Form{
                List {
                    ForEach(timeIntervals, id: \.self) { timeInterval in
                        Text(timeInterval)
                    }
                }
                
                
                Section(header:Text("Choose a period to add")){
                    HStack {
                        DatePicker("From", selection: $startTime, displayedComponents: .hourAndMinute)
                        DatePicker("To", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute)
                    }
                }
                    Section(header:Text("Choose a period to remove")){
                        HStack {
                            DatePicker("From", selection: $startTime1, displayedComponents: .hourAndMinute)
                            DatePicker("To", selection: $endTime1, in: startTime1..., displayedComponents: .hourAndMinute)
                        }
                }
                


                if showAdditionalPickers{
                    Section(header: Text("Period Added")){
                        ForEach(additionalStartDates.indices, id: \.self) { index in
                            HStack {
                                DatePicker("From", selection: $additionalStartDates[index], displayedComponents: .hourAndMinute)
                                DatePicker("To", selection: $additionalEndDates[index], in: additionalStartDates[index]..., displayedComponents: .hourAndMinute)
                            }
                        }
                    }
                
                }
            }
            .onAppear {UIDatePicker.appearance().minuteInterval = minterval}
            .navigationBarTitle("Working Hours on \(dayNames[daynum])")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", action: {
                        presentationMode.wrappedValue.dismiss()
                        confirm()
                    })
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Exit", action: {presentationMode.wrappedValue.dismiss()})
                }
                
                ToolbarItem(placement: .bottomBar){
                    HStack{
                        Button(action: {
//                            AddTime()
                            let begintime = getHourAndMin(time: startTime)
                            let endtime = getHourAndMin(time: endTime)

                            taskData.globalStoreData.addWorkingHour(at: daynum, from: begintime.index, to: endtime.index)
                        }) {Text("Add")}
                        
                        Spacer()
                        Button(action: {
//                            DeleteTime()
                            let begintime = getHourAndMin(time: startTime1)
                            let endtime = getHourAndMin(time: endTime1)

                            taskData.globalStoreData.cutWorkingHour(at: daynum, from: begintime.index, to: endtime.index)
                        }) {Text("Delete")}
                    }
                }
            }
        }
    }
    
    
    
    func confirm(){
        //plan:sort periods
        
        //实现方式可以是传入additionalStartDates和additionalendDates这两个存储了所有添加过period的开始和结束时间
        //之后进行整理并返回一个包含整理之后的period的数组
//        SortPeriods()
        //write in dataset
        //这里可以用for each的方式来写入每一段独立的period进入taskData.globalStoreData.workingHours[daynum]
        //之后检查confirm了之后，是否实时在上面的list中显示taskData.globalStoreData.workingHours[daynum]
        
        
        //...丑陋的测试方法
//        let begintime = getHourAndMin(time: startTime)
//        let endtime = getHourAndMin(time: endTime)
//        let begintime1 = getHourAndMin(time: startTime1)
//        let endtime1 = getHourAndMin(time: endTime1)
//        print("......Start testing......")
//        print("begintime_index: \(begintime.index)")
//        print("endtime_index: \(endtime.index)")
//        print("begintime1_index: \(begintime1.index)")
//        print("endtime1_index: \(endtime1.index)")
//        taskData.globalStoreData.addWorkingHour(at: daynum, from: begintime.index, to: endtime.index)
//        taskData.globalStoreData.cutWorkingHour(at: daynum, from: begintime1.index, to: endtime1.index)
//        print(taskData.globalStoreData.workingHours[daynum])
//        print("......End testing......")
        //丑陋的测试方法......
        
    }
    
    func SortPeriods(){
        
    }
    
    func getHourAndMin(time:Date)->(hour:Int, min:Int,index: Int){
        let calendar = Calendar.current
        hour = calendar.component(.hour, from: time)
        min = calendar.component(.minute, from: time)
        index = 2*hour
        if min == 30{index += 1}
        return (hour,min,index)
    }
    
    func AddTime(){
        //控制ui
        self.showAdditionalPickers = true
        self.additionalStartDates.append(Date())
        self.additionalEndDates.append(Date())
        self.additionalDescription.append("")
        //对begin time和end time判断：如果end time < start time 则添加失败
        
    }
    
    //实现时可以参考AddTime()
    func DeleteTime(){
        //控制ui

        //对begin time和end time判断：如果end time < start time 则添加失败
        
    }
    
    
    private func getTimeIntervals() -> [String] {
        var timeIntervals = [String]()
        var startInterval = ""
        var endInterval = ""

        for index in 0..<taskData.globalStoreData.workingHours[daynum].count {
            if taskData.globalStoreData.workingHours[daynum][index] {
                if startInterval == "" {
                    startInterval = getFormattedTime(index)
                }
                endInterval = getFormattedTime(index + 1)
            } else {
                if startInterval != "" {
                    timeIntervals.append("\(startInterval) - \(endInterval)")
                    startInterval = ""
                    endInterval = ""
                }
            }
        }

        if startInterval != "" {
            timeIntervals.append("\(startInterval) - \(endInterval)")
        }

        return timeIntervals
    }

    private func getFormattedTime(_ index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let time = Calendar.current.date(byAdding: .minute, value: 30 * index, to: date!)!
        return dateFormatter.string(from: time)
    }
    
}


struct AddWorkHour_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkHour(daynum: 6)
            .environmentObject(Tasks())
    }
}

struct DatePair: Hashable {
    var startDate: Date
    var endDate: Date
}
