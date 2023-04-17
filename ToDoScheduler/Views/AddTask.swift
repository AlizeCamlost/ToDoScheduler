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
    
    var body: some View {
        VStack {
            Text("Input new task:")
            TextField("TaskName",text: $taskName)
            TextField("Estimated Time Cost",text: $estimatedCost)
            DatePicker(selection: $selectDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]){
                Text("Date")
            }
            Button(action:{
                taskData.addTask(taskName: taskName, deadline: selectDate, cost: Int(estimatedCost)!)
            }, label: {
                Text("Click to Add")
            })
        }
    }
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        AddTask()
            .environmentObject(Tasks())
    }
}
