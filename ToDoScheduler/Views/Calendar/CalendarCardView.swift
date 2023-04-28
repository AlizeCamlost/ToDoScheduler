//
//  CalendarCardView.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/29.
//

import SwiftUI

struct CalendarCardView: View {
    var content:CalendarGridStruct
    @State private var isPresented = false
    @State private var presentOption: Int?
    @State private var segLayout:[Int] = []
    @State private var segEnabled:[Bool] = []
    @State private var segId:[Int] = []
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    private let timeAxis: [Date] = {
        var axis:[Date] = []
        
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "yyyy-MM-dd"
        
        var iter_time = Date()
        let timeCut = dateformatter1.string(from: iter_time)
        iter_time = dateformatter1.date(from: timeCut)!
        for i in 0...48 {
            axis.append(iter_time)
            iter_time = iter_time.addingTimeInterval(TimeInterval(30*60))
        }
        
        return axis
    }()
    
    var body: some View {
        VStack {
            HStack {
                Text(content.day, style: .date)
                    .font(.title)
                Spacer()
            }
            ScrollView{
                HStack{
                    VStack(spacing:0){
                        ForEach(timeAxis, id:\.self){ ta in
                            Text(timeFormatter.string(from: ta))
                                .font(.subheadline)
                                .frame(height: 40)
                                //.border(.gray)
                        }
                    }
                    VStack(spacing:0){
                        ForEach(0..<segLayout.count, id:\.self){ slid in
                            VStack{
                                if segEnabled[slid] {
                                    Button(action:{
                                        presentOption = slid
                                        isPresented.toggle()
                                        print("presentOption:\(presentOption ?? -1)")
                                    }){
                                        VStack {
                                            HStack {
                                                Text(content.segDesc[segId[slid]].desp)
                                                    .foregroundColor(.black)
                                                Spacer()
                                            }.padding(.leading, 5)
                                            Spacer()
                                        }
                                        .background(.orange.opacity(0.4))
                                        .cornerRadius(5)
                                        .padding(3)
                                    }
                                }
                            }
                            .frame(height: 40*CGFloat(segLayout[slid]))
                            //.border(.gray)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear{
            var p = 0
            var q = -1
            for i in 0..<content.segDesc.count{
                q = content.segDesc[i].startT - 1
                if p<=q {
                    segLayout.append(q-p+1)
                    segEnabled.append(false)
                    segId.append(-1)
                }
                
                p = content.segDesc[i].startT
                q = content.segDesc[i].endT
                segLayout.append(q-p+1)
                segEnabled.append(true)
                segId.append(i)
            }
            p = q+1
            q = 47
            if p<=q {
                segLayout.append(q-p+1)
                segEnabled.append(false)
                segId.append(-1)
            }
        }
        .sheet(isPresented: $isPresented, content: {
            if let selected = presentOption{
                SegmentCardView(detail: content.segDesc[segId[selected]])
            }
        })
    }
}

struct SegmentCardView: View{
    @State var detail:passingSegStruct
    
    var body: some View {
        VStack {
            Text(detail.desp)
        }
    }
}

struct CalendarCardView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCardView(content:CalendarGridStruct(dayId: 13, segDesc: [passingSegStruct(desp:"asdf",startT:5,endT:10)]))
    }
}
