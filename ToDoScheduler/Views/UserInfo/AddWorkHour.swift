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
    @State private var globalStartTime = Date()
    @State private var globalEndTime = Date()
    
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

                
                Section(header: Text("Add a Period")){
                    if showAdditionalPickers{
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
                        //                        presentationMode.wrappedValue.dismiss()
                        confirm()
                    })
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: {presentationMode.wrappedValue.dismiss()})
                }
                
                ToolbarItem(placement: .bottomBar){
                    Button(action: {
                        AddTime()
                    }) {Text("Add")}
                }
            }
        }
    }
    
    
    
    func confirm(){
        //sort periods
        SortPeriods()
        //write in dataset
        
        let begintime = getHourAndMin(time: globalStartTime)
        let endtime = getHourAndMin(time: globalEndTime)
        print("......Start testing......")
        print("begintime_index: \(begintime.index)")
        print("endtime_index: \(endtime.index)")
        taskData.globalStoreData.addWorkingHour(at: daynum, from: begintime.index, to: endtime.index)
        print(taskData.globalStoreData.workingHours[daynum])
        print("......End testing......")
        
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
        //对begin time和end time判断
        
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
