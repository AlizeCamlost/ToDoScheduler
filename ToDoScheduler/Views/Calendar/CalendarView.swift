//
//  CalendarView.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import SwiftUI

struct CalendarView: View {
    //@State private var isRedrawClicked = false
    @EnvironmentObject var taskData: Tasks
    @State private var localNotificationManager = LocalNotificationManager()
    
    private var gridItemLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    let dateFmtTitle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM·YYYY"
        return formatter
    }()
    
    var tasklist:[Taskstruct]{
        taskData.tasklist
    }
    
    var segmentlist:[Segmentstruct]{
        taskData.segmentlist
    }
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button(action: {
                        print("before:\(taskData.dayCalHold)")
                        let calendar = Calendar.current
                        let previousMonth = calendar.date(byAdding: .month, value: -1, to: taskData.dayCalHold)!
                        taskData.dayCalHold = previousMonth
                        print("after:\(taskData.dayCalHold)")
                        //isRedrawClicked.toggle()
                    }){
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue.opacity(0.8))
                    }
                    Text(dateFmtTitle.string(from: taskData.dayCalHold))
                        .font(.title)
                    Button(action: {
                        print("before:\(taskData.dayCalHold)")
                        let calendar = Calendar.current
                        let nextMonth = calendar.date(byAdding: .month, value: 1, to: taskData.dayCalHold)!
                        taskData.dayCalHold = nextMonth
                        print("after:\(taskData.dayCalHold)")
                        //isRedrawClicked.toggle()
                    }){
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue.opacity(0.8))
                    }
                    Spacer()
                }.toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button(action: {
                            localNotificationManager.scheduleNotificationForEvent(segmentlist: segmentlist, tasklist: tasklist)
                        }) {
                            Image(systemName: "bell.circle")
                        }
                    }
                }
                
                
                
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
                                .frame(maxWidth: .infinity, idealHeight: 80, maxHeight: 80)
                                //.border(Color.gray)
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(Tasks())
    }
}
