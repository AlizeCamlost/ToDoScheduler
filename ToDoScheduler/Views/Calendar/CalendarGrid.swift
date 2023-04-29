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
                    VStack(spacing:3){
                        Text(String(content.dayId))
                            .foregroundColor(.black)
                            //.border(Color.gray)
                        ForEach(content.segDesc.prefix(4), id:\.self){ despStr in
//                            Text(despStr.desp)
//                                .font(.system(size: 12))
//                                .foregroundColor(Color.black.opacity(0.6))
//                                .background(Color.orange.opacity(0.4))
//                                .padding(.bottom,1)
                            Color.clear
                                .overlay(
                                    Text(despStr.desp)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.black.opacity(0.6))
                                )
                                .background(Color.orange.opacity(0.4))
                                .cornerRadius(5)
                                .padding(0)
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
        CalendarGrid(content:CalendarGridStruct(dayId: 13, segDesc: [passingSegStruct(desp:"asdf",startT:5,endT:10),passingSegStruct(desp:"asdf",startT:11,endT:15)]))
    }
}
