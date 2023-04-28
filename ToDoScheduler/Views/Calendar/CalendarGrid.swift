//
//  CalendarGrid.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/28.
//

import SwiftUI

struct CalendarGrid: View {
    var content:CalendarGridStruct
    
    var body: some View {
        VStack{
            if(content.dayId != 0){
                NavigationLink(destination: CalendarCardView(content: content)){
                    VStack{
                        Text(String(content.dayId))
                            .foregroundColor(.black)
                            //.border(Color.gray)
                        ForEach(content.segDesc, id:\.self){ despStr in
                            Color.clear
                                .overlay(
                                    Text(despStr.desp)
                                        .foregroundColor(Color.black.opacity(0.6))
                                )
                                .background(Color.orange.opacity(0.4))
                                .cornerRadius(5)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CalendarGrid_Previews: PreviewProvider {
    static var previews: some View {
        CalendarGrid(content:CalendarGridStruct(dayId: 13, segDesc: [passingSegStruct(desp:"asdf",startT:5,endT:10)]))
    }
}
