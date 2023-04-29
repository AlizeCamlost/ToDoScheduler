//
//  AddWorkDay.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/24.
//

import SwiftUI

struct AddWorkDay: View {
    @EnvironmentObject var taskData: Tasks
    
    @State private var selectedDays = [Int]()
    @Environment(\.presentationMode) var presentationMode
    
    let dayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var dayNames1 = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State var days: [String] = []
    @State var showWorkHourView = false
    @State var isPresent:Int = 0
    @State var isPresent2:Int = 0
    
    func updateWorkDay(i :Int){
        print(selectedDays.description)
        if selectedDays.contains(i){
            taskData.globalStoreData.setWorkingDay(enable: i)
        }
    }
    
    func updateWorkDay1(){
        print(selectedDays.description)
        for i in 0...6{
            if selectedDays.contains(i){
                taskData.globalStoreData.setWorkingDay(enable: i)
            }else{
                taskData.globalStoreData.setRestDay(disable: i)
            }
        }
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header:Text("Days")){
                    ForEach(0..<7, id: \.self){day in
                        HStack{
                            Button(dayNames[day]){
                                if taskData.globalStoreData.workingDays[day] {
                                    taskData.globalStoreData.setRestDay(disable: day)
                                }else{
                                    taskData.globalStoreData.setWorkingDay(enable: day)
                                }
                            }
                            
                            .foregroundColor(taskData.globalStoreData.workingDays[day] ? .blue : .black)
                            Spacer()

                            if taskData.globalStoreData.workingDays[day] {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                            
                            
                            Image(systemName: "chevron.right")
                                .opacity(0.5)
                                .font(.system(size:14))
                                .onTapGesture {
                                    showWorkHourView = true
                                    isPresent = day
                                }
                                .sheet(isPresented: $showWorkHourView,content:{
                                    AddWorkHour(daynum: isPresent2)
                                        .onAppear{
                                            isPresent2 = isPresent
                                        }
                                })

                        }
                    }
                }
                
            }
            .toolbar {

                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", action: {
//                        updateWorkDay1()
                        presentationMode.wrappedValue.dismiss()
                    })
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .navigationBarTitle("Adding Workdays")
        }
    }
}

struct AddWorkDay_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkDay()
            .environmentObject(Tasks())
        
    }
}
