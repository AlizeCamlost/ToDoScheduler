//
//  TaskData.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct GlobalStoreData:Codable{
    // User Info
    var username: String = ""
    var userAddress: String = ""
    var userBirthday: String = ""
    
    // View hold state
    //var dayHoldCalendar: String = ""
    
    // Model hold state
    var taskCounter:Int = 0
    var segmentCounter:Int = 0
    var dayCounter: Int = 0
    
    var workingDays:[Bool] = [Bool](repeating: false, count: 7)
    var workingHours:[[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: 48), count: 7)
    
    mutating func setWorkingDay(enable day:Int){
        workingDays[day]=true
    }
    
    mutating func setRestDay(disable day:Int){
        workingDays[day]=false
    }
    
    mutating func addWorkingHour(at day:Int ,from start:Int, to end:Int){
        for i in start..<end {
            workingHours[day][i]=true
        }
    }
    
    mutating func cutWorkingHour(at day:Int ,from start:Int, to end:Int){
        for i in start..<end {
            workingHours[day][i]=false
        }
    }
}

struct passingSegStruct:Hashable{
    var desp:String
    var startT:Int
    var endT:Int
}

struct CalendarGridStruct:Hashable{
    var dayId:Int = 0
    var day:Date = Date()
    var segDesc:[passingSegStruct] = []
    
    mutating func addSegDesc(str:String, i1:Int, i2:Int){
        segDesc.append(passingSegStruct(desp: str, startT: i1, endT: i2))
    }
}

final class Tasks: ObservableObject{
    //Initialize a TASKS when startint the application
    @Published var globalStoreData:GlobalStoreData=load("globalStore.json")     // Global parameters;
    @Published var tasklist:[Taskstruct]=load("tasklistData.json")              // task list;
    @Published var segmentlist:[Segmentstruct]=load("segmentlistData.json")     // a task split into several segments, all segments of all tasks managed by the list;
    @Published var routinelist:[String:Daystruct]=load("routinelistData.json")  // days are filled with segments according to rules;
    
    // view hold state
    var today = Date()
    var dayCalHold = Date()
    //@Published var calenderGridList:[CalendarGridStruct] = []
    
    func returnCalender()->[CalendarGridStruct]{
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: dayCalHold)
        let startOfMonth = calendar.date(from: components)!
        //第一天是从星期天算起，weekday在 1~7之间
        let weekday = calendar.dateComponents([.weekday], from: startOfMonth).weekday
        var res:[CalendarGridStruct] = []
        print("weekday\(weekday!)")
        for _ in 1..<weekday!{
            res.append(CalendarGridStruct(dayId: 0))
        }
        let range = calendar.range(of: .day, in: .month, for: dayCalHold)
        let numberOfDays = range!.count
        for i in 1...numberOfDays{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            let theDay_date = startOfMonth.addingTimeInterval(TimeInterval(24*60*60*(i-1)))
            let theDay_Str = dateformatter.string(from: theDay_date)
            
            var theDay = CalendarGridStruct(dayId: i, day: theDay_date)
            
            if let rt = routinelist[theDay_Str] {
                for sid in rt.segmentsId{
                    let tid = segmentlist[sid].taskId
                    let taskDesp = tasklist[tid].description
                    let sT = segmentlist[sid].startTime
                    let eT = segmentlist[sid].endTime
                    theDay.addSegDesc(str: taskDesp, i1:sT, i2:eT)
                }
            }
            
            res.append(theDay)
        }
        
        print("Calendar:")
        print(res)
        
        return res
    }
    
    
    // Add new task into tasklist, split it into segments and allocate them into days
    func addTask(taskName: String, deadline: Date, cost:Int, gran:Int=2, schpre:Int=1, desp:String=""){
        print("try to add")
        print("routinelist\(routinelist)")
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "yyyy-MM-dd"
        let dateformatter2 = DateFormatter()
        dateformatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let ddlStr = dateformatter2.string(from: deadline)
        var newTask = Taskstruct(id: globalStoreData.taskCounter, taskname: taskName,deadline: ddlStr,estimatedCost: cost, granularity: gran, schedulePrefernece: schpre, description: desp)
        
        var segNum = cost/gran
        var nextGran = cost - segNum*gran
        if gran*segNum<cost {
            segNum+=1
        }
        var haveCost = 0
        
        print("segNum:\(segNum),cost:\(cost),nextGran:\(nextGran)")
        
        if schpre==1 { // schedule preference: as soon as possible
            let today = Date()
            let startDayStr = dateformatter1.string(from: today)
            var startDay = dateformatter1.date(from: startDayStr)
            startDay = startDay!.addingTimeInterval(TimeInterval(24*60*60))
            let endDayStr = dateformatter1.string(from: deadline)
            let endDay = dateformatter1.date(from: endDayStr)
            
            var iter_day = startDay
            print("startDay:\(startDay!)")
            /* allocate segs to the days, from tomorrow to ddl */
            while true{
                print("iter_day:\(iter_day!)")
                let dateStr = dateformatter1.string(from:iter_day!)
                print("dateStr:\(dateStr)")
                var thisDay:Daystruct
                if routinelist[dateStr] == nil{
                    print("is0")
                    thisDay = Daystruct(id: globalStoreData.dayCounter, date: dateStr)
                    routinelist[dateStr] = thisDay
                    globalStoreData.dayCounter += 1
                }else{
                    print("is1")
                    thisDay = routinelist[dateStr]!
                }
                
                var checkCotSlot = 0
                var checkCotSch = 0
                for p in 0..<48 {
                    if thisDay.timeSlot[p]{
                        checkCotSlot += 1
                    }
                    if thisDay.schedule[p]{
                        checkCotSch += 1
                    }
                }
                print("checkCotSlot:\(checkCotSlot), checkCotSch:\(checkCotSch)")
                
                var cot:Int = 0
                /* check if thisDay is allocatable, and how much segs can be allocated */
                for p in 0..<48 {
                    if thisDay.timeSlot[p] && !thisDay.schedule[p] {
                        cot += 1
                        if cot == gran {
                            // TODO: allocate seg
                            for i in (p-gran+1)...p {
                                thisDay.schedule[i] = true
                            }
                            let theDayStr = dateformatter1.string(from: iter_day!)
                            let newSegment = Segmentstruct(id: globalStoreData.segmentCounter, taskId: globalStoreData.taskCounter, day: theDayStr, startTime: p-gran+1, endTime: p)
                            thisDay.segmentsId.append(globalStoreData.segmentCounter)
                            newTask.segmentsId.append(globalStoreData.segmentCounter)
                            segmentlist.append(newSegment)
                            globalStoreData.segmentCounter += 1
                            
                            haveCost += nextGran
                            segNum -= 1
                            if segNum == 1 {
                                nextGran = cost - haveCost
                            }
                            if segNum == 0 {
                                break   // allocate succeed
                            }
                            
                            cot = 0
                        }
                    }else{
                        cot = 0
                    }
                }
                if segNum == 0 {
                    break   // allocate succeed
                }
                
                if iter_day == endDay {
                    break   // out of time
                }
                iter_day = iter_day!.addingTimeInterval(TimeInterval(24*60*60))
            }
        }else if schpre==2{
            
        }else if schpre==3{
            
        }
        
        if segNum == 0 {
            tasklist.append(newTask)
            globalStoreData.taskCounter += 1
            print("Successfully Allocated")
        }
        else {
            fatalError("No enough time! Allocating failed")
            // TODO: rollback operations
            // ...
        }
    }
    
    func editSegment(segmentId:Int, day:Date, startTime:Int, endTime:Int)->Int{
        // TODO: ...
        // ...
        return 0
    }
    
    func saveData(){
        save(dir:"globalStore.json", data:globalStoreData)
        save(dir:"tasklistData.json", data:tasklist)
        save(dir:"segmentlistData.json", data: segmentlist)
        save(dir:"routinelistData.json", data:routinelist)
    }
    
    func testprint(){
        print(globalStoreData.username)
        print(globalStoreData.userAddress)
        print(globalStoreData.userBirthday)
    }
}


// Data load and save

func load<T:Decodable>(_ filename:String)->T{
    let data: Data
    print(filename)
    
    guard let file=Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Open file failed.")
    }
    
    do{
        data = try Data(contentsOf: file)
    }catch{
        fatalError("Read file failed.")
    }
    
    do{
        let decoder=JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch{
        fatalError("Decode JSON failed.")
    }
}

func save<T:Encodable>(dir filename:String, data:T){    // save object
    let file=Bundle.main.url(forResource: filename, withExtension: nil)
    
    let dataWrite = try? JSONEncoder().encode(data)
    print(dataWrite!)
    do{
        try dataWrite?.write(to: file!)
    }catch{
        fatalError("Write file failed.")
    }
}

func save<T:Encodable>(dir filename:String, data:[T]){      // save list
    let file=Bundle.main.url(forResource: filename, withExtension: nil)
    
    let dataWrite = try? JSONEncoder().encode(data)
    print(dataWrite!)
    do{
        try dataWrite?.write(to: file!)
    }catch{
        fatalError("Write file failed.")
    }
}
