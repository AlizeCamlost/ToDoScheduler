//
//  CalendarView.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var taskData: Tasks
    
    var tasklist:[Taskstruct]{
        taskData.tasklist
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(tasklist){ task in
                    TaskRow(task: task)
                }
            }
            Button(action: {
                taskData.saveData()
            }, label: {
                Text("Save Data")
            })
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(Tasks())
    }
}
