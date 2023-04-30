//
//  CalendarGrid.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/28.
//

import SwiftUI

struct CalendarGrid: View {
    var content:CalendarGridStruct
    
    let colorNumbers: [Color] = [
            Color(UIColor(red: 0.490, green: 0.514, blue: 0.992, alpha: 1)),
            Color(UIColor(red: 1.000, green: 0.557, blue: 0.431, alpha: 1)),
            Color(UIColor(red: 0.647, green: 0.882, blue: 0.486, alpha: 1)),
            Color(UIColor(red: 1.000, green: 0.871, blue: 0.255, alpha: 1)),
            Color(UIColor(red: 0.443, green: 0.937, blue: 0.729, alpha: 1))
        ]
    
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
                                    Text(despStr.tname)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.black.opacity(0.6))
                                )
                                .background(colorNumbers[despStr.imp].opacity(0.4))
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
        CalendarGrid(content:CalendarGridStruct(dayId: 13, segDesc: [passingSegStruct(tname:"tasdf",desp:"asdf",startT:5,endT:10,imp:1),passingSegStruct(tname:"tasdf",desp:"asdf",startT:11,endT:15,imp:1)]))
    }
}
