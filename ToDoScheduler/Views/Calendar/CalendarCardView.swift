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
    @State private var presentOption: Int = 0
    @State private var presentOption2: Int = 0
    @State private var segLayout:[Int] = []
    @State private var segEnabled:[Bool] = []
    @State private var segId:[Int] = []
    
    let colorNumbers: [Color] = [
                Color(UIColor(red: 180/255, green: 206/255, blue: 234/255, alpha: 1)),
                Color(UIColor(red: 142/255, green: 170/255, blue: 214/255, alpha: 1)),
                Color(UIColor(red: 118/255, green: 146/255, blue: 201/255, alpha: 1)),
                Color(UIColor(red: 94/255, green: 119/255, blue: 181/255, alpha: 1)),
                Color(UIColor(red: 54/255, green: 88/255, blue: 164/255, alpha: 1)),
                Color(UIColor(red: 21/255, green: 37/255, blue: 77/255, alpha: 1))
            ]
    
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
                        VStack{}.frame(height:40)
                        ForEach(0..<segLayout.count, id:\.self){ slid in
                            VStack{
                                if segEnabled[slid] {
                                    Button(action:{
                                        presentOption = segId[slid]
                                        print("presentOption:\(presentOption)")
                                        isPresented.toggle()
                                    }){
                                        VStack {
                                            HStack {
                                                Text(content.segDesc[segId[slid]].tname)
                                                    .foregroundColor(Color.white)
                                                Spacer()
                                            }.padding(.leading, 5)
                                            Spacer()
                                        }
                                        .background(colorNumbers[content.segDesc[segId[slid]].imp].opacity(0.8))
                                        .cornerRadius(5)
                                        .padding(3)
                                    }
                                }else{
                                    Rectangle()
                                        .opacity(0)
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
            print("content:\(content.segDesc)")
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
                
                p = q+1
            }
            //p = q+1
            q = 48
            if p<=q {
                segLayout.append(q-p+1)
                segEnabled.append(false)
                segId.append(-1)
            }
            print(segLayout)
            print(segId)
        }
        .sheet(isPresented: $isPresented, content: {
            SegmentCardView(detail: content.segDesc[presentOption])
        })
    }
}

struct SegmentCardView: View{
    var detail:passingSegStruct
    
    var body: some View {
        NavigationView{
            VStack {
                Text(detail.desp)
                    .font(.system(size: 24))
                    .padding()
                Spacer()
            }
            .navigationTitle(Text(detail.tname))
//            VStack {
//                Text(detail.tname)
//                Text(detail.desp)
//            }
        }
        

    }
}

struct CalendarCardView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarCardView(content:CalendarGridStruct(dayId: 13, segDesc: [passingSegStruct(tname:"tasdf",desp:"asdf",startT:5,endT:10,imp:1)]))
    }
}
