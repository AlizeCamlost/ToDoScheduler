//
//  CalendarView.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var taskData: Tasks
    
//  *************
    private var symbols = ["keyboard", "hifispeaker.fill", "printer.fill", "tv.fill", "desktopcomputer", "headphones", "tv.music.note", "mic", "plus.bubble", "video"]
    private var colors: [Color] = [.yellow, .purple, .green]
    private var gridItemLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let daysInMonth = 31
// ***********
    
    var tasklist:[Taskstruct]{
        taskData.tasklist
    }
    
    var segmentlist:[Segmentstruct]{
        taskData.segmentlist
    }
    
    var body: some View {
        NavigationView{
            VStack {
                LazyVGrid(columns: gridItemLayout) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.headline)
                            .frame(height: 40)
                    }
                }
                .padding()
                ScrollView{
                    LazyVGrid(columns: gridItemLayout, spacing: 0) {
                        ForEach(taskData.returnCalender(), id:\.self){ cldst in
                            CalendarGrid(content: cldst)
                                .frame(maxWidth: .infinity, idealHeight: 80)
                                //.border(Color.gray)
                        }
                    }
                    .padding()
                    
                }
                
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(Tasks())
    }
}
