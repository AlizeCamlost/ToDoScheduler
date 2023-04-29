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
    @State private var granularity: String = ""
    @State private var schedulePrefernece: String = ""
    @State private var desp: String = ""
    
    var body: some View {
        Section{
            VStack {
                Text("Input new task:")
                TextField("TaskName",text: $taskName)
                TextField("Estimated Time Cost",text: $estimatedCost)
                DatePicker(selection: $selectDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]){
                    Text("Ddealine")
                }
                TextField("Granularity",text: $granularity)
                TextField("SchedulePrefernece",text: $schedulePrefernece)
                TextField("Description",text: $desp)
                Button(action:{
                    var gran = Int(granularity) ?? 2
                    var schpre = Int(schedulePrefernece) ?? 1
                    taskData.addTask(taskName: taskName, deadline: selectDate, cost: Int(estimatedCost)!, gran:gran, schpre:schpre, desp: desp)
                }, label: {
                    Text("Click to Add")
                })
            }
        }
        
    }
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        AddTask()
            .environmentObject(Tasks())
    }
}
