//
//  CalendarGrid.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/28.
//

import SwiftUI

struct CalendarGrid: View {
    @Environment(\.colorScheme) var colorScheme
    var content:CalendarGridStruct
    
    let colorNumbers: [Color] = [
                Color(UIColor(red: 180/255, green: 206/255, blue: 234/255, alpha: 1)),
                Color(UIColor(red: 142/255, green: 170/255, blue: 214/255, alpha: 1)),
                Color(UIColor(red: 188/255, green: 146/255, blue: 201/255, alpha: 1)),
                Color(UIColor(red: 94/255, green: 119/255, blue: 181/255, alpha: 1)),
                Color(UIColor(red: 54/255, green: 88/255, blue: 164/255, alpha: 1)),
                Color(UIColor(red: 21/255, green: 37/255, blue: 77/255, alpha: 1))
            ]
    
    var body: some View {
        VStack{
            if(content.dayId != 0){
                NavigationLink(destination: CalendarCardView(content: content)){
                    VStack(spacing:3){
                        Text(String(content.dayId))
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            //.border(Color.gray)
                        ForEach(content.segDesc.prefix(4), id:\.self){ despStr in
                            Color.clear
                                .overlay(
                                    Text(despStr.tname)
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.white)
                                )
                                .background(colorNumbers[despStr.imp].opacity(0.8))
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
