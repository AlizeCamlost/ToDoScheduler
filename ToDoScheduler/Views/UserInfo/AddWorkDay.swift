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
    
    func updateWorkDay(){
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
                                if selectedDays.contains(day){
                                    selectedDays.removeAll(where: { $0 == day})
                                }else{selectedDays.append(day)}
                            }
                            .foregroundColor(selectedDays.contains(day) ? .blue : .black)
                            Spacer()
                            if (selectedDays.contains(day)){
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
            }
            .toolbar {

                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm", action: {
                        updateWorkDay()
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
    }
}





////
////  AddWorkDay.swift
////  ToDoScheduler
////
////  Created by Camlost 施 on 2023/4/24.
////
//
//import SwiftUI
//
//struct AddWorkDay: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct AddWorkDay_Previews: PreviewProvider {
//    static var previews: some View {
//        AddWorkDay()
//    }
//}
