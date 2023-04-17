//
//  ToDoSchedulerApp.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/2/5.
//

import SwiftUI

@main
struct ToDoSchedulerApp: App {
    @StateObject private var taskData = Tasks()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskData)
        }
    }
}
