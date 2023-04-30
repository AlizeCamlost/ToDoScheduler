//
//  AddTask.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/17.
//

import SwiftUI

struct AddTask: View {
    @EnvironmentObject var taskData: Tasks
    //@State private var taskId: Int = 0
    @State private var taskName: String = ""
    @State private var estimatedCost: String = ""
    @State private var selectDate = Date()
    @State private var granularity: String = "1h"
    @State private var schedulePreference: String = "quick"
    @State private var desp: String = ""
    @State private var importance: Int = 1
    @State private var showAllocationAlert = false
    @State private var success = false
    
    let granularityOptions = ["30min", "1h", "2h", "4h"]
    let schedulePreferenceOptions = ["quick", "ordinary", "delay"]
    
    var body: some View {
        NavigationView {
            Form{
                List {
                    Section(header: Text("Input new task:")
                    ) {
                        HStack {
                            Text("TaskName")
                            TextField("TaskName",text: $taskName)
                        }
                        
                        HStack {
                            Text("Time Cost")
                            TextField("Estimated Time Cost",text: $estimatedCost)
                            Text("×30mins")
                                .font(.system(size:12))
                                .opacity(0.6)
                        }
                        
                        HStack {
                            DatePicker(selection: $selectDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]){
                                Text("Deadline")
                            }
                            .onAppear {UIDatePicker.appearance().minuteInterval = 30}
                        }
                        
                        HStack {
                            Text("Granularity")
                            Picker("Granularity", selection: $granularity) {
                                ForEach(granularityOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        HStack {
                            Text("Preference")
                            Picker("Schedule Preference", selection: $schedulePreference) {
                                ForEach(schedulePreferenceOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        HStack {
                            Text("Importance:")
                            Picker("Importance", selection: $importance) {
                                ForEach(1...5, id: \.self) { number in
                                    Text("\(number)")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        HStack {
                            Text("Description")
                            TextField("Description",text: $desp)
                        }
                        
                        HStack {
                            Spacer()
                            Button(action:{
                                let gran = getGranularityValue()
                                let schpre = getSchedulePreferenceValue()
                                success = taskData.addTask(taskName: taskName, deadline: selectDate, cost: Int(estimatedCost)!, gran: gran, schpre: schpre, ipd: importance, desp: desp)
                                
                                //allocationSuccess = taskData.allocationSuccess ?? false
                                showAllocationAlert = true
                                taskName = ""
                                estimatedCost = ""
                                desp = ""
                                granularity = "1h"
                                schedulePreference = "quick"
                                importance = 1
                            }, label: {
                                Text("Click to Add")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .cornerRadius(8)
                            })
                            Spacer()
                        }.alert(isPresented: $showAllocationAlert, content: {
                            showAlert(allocationSuccess: success)
                        })
                    }
                    //.font(.system(size: 18))
                }
            }
            .listStyle(GroupedListStyle()) // 设置列表样式为分组列表
            .navigationBarTitle("Add Task") // 设置导航栏标题
        }
    }
    
    func showAlert(allocationSuccess: Bool) -> Alert {
        if allocationSuccess {
            return Alert(title: Text("Success"), message: Text("Successfully Allocated"), dismissButton: .default(Text("OK")))
        } else {
            return Alert(title: Text("Failure"), message: Text("No enough time! Allocating failed"), dismissButton: .default(Text("OK")))
        }
    }
    
    func getGranularityValue() -> Int {
        switch granularity {
        case "30min":
            return 1
        case "1h":
            return 2
        case "2h":
            return 4
        case "4h":
            return 8
        default:
            return 2
        }
    }
    
    func getSchedulePreferenceValue() -> Int {
        switch schedulePreference {
        case "quick":
            return 1
        case "ordinary":
            return 2
        case "delay":
            return 3
        default:
            return 1
        }
    }
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        AddTask()
            .environmentObject(Tasks())
    }
}


////
////  AddTask.swift
////  ToDoScheduler
////
////  Created by Camlost 施 on 2023/4/17.
////
//
//import SwiftUI
//
//struct AddTask: View {
//    @EnvironmentObject var taskData: Tasks
//    //@State private var taskId: Int = 0
//    @State private var taskName: String = ""
//    @State private var estimatedCost: String = ""
//    @State private var selectDate = Date()
//    @State private var granularity: String = ""
//    @State private var schedulePrefernece: String = ""
//    @State private var desp: String = ""
//
//    var body: some View {
//        Section{
//            VStack {
//                Text("Input new task:")
//                TextField("TaskName",text: $taskName)
//                TextField("Estimated Time Cost",text: $estimatedCost)
//                DatePicker(selection: $selectDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]){
//                    Text("Ddealine")
//                }
//                TextField("Granularity",text: $granularity)
//                TextField("SchedulePrefernece",text: $schedulePrefernece)
//                TextField("Description",text: $desp)
//                Button(action:{
//                    let gran = Int(granularity) ?? 2
//                    let schpre = Int(schedulePrefernece) ?? 1
//                    taskData.addTask(taskName: taskName, deadline: selectDate, cost: Int(estimatedCost)!, gran:gran, schpre:schpre, desp: desp)
//                }, label: {
//                    Text("Click to Add")
//                })
//            }
//        }
//
//    }
//}
//
//struct AddTask_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTask()
//            .environmentObject(Tasks())
//    }
//}
