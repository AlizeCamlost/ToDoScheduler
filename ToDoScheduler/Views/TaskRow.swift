//
//  TaskRow.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/17.
//

import SwiftUI

struct TaskRow: View {
    var task: Taskstruct
    
    var body: some View {
        VStack {
            Text(String(task.id))
            Text(task.description)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var tasks = Tasks().tasklist
    static var previews: some View {
        Group{
            TaskRow(task: tasks[0])
            TaskRow(task: tasks[1])
        }
    }
}
