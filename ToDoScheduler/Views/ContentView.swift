//
//  ContentView.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/2/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            VStack {
                Text("The Calendar")
                CalendarView()
            }
                .font(.title)
                .tabItem({
                    Image(systemName: "calendar")
                    Text("Schedule")
                })
                .tag(0)
            VStack {
                Text("New Task Info")
                AddTask()
            }
                .font(.title)
                .tabItem({
                    Image(systemName: "calendar.badge.plus")
                    Text("Add New")
                })
            .tag(1)
            Text("Profile & Statistics & Settings")
                .font(.title)
                .tabItem({
                    Image(systemName: "gear")
                    Text("More")
                })
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Tasks())
    }
}
