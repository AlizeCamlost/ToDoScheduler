//
//  TaskData.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct GlobalStoreData:Codable{
    //var taskCounter:Int=0
    var taskCounter:Int = 0
    var segmentCounter:Int = 0
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

final class Tasks: ObservableObject{
    //Initialize a TASKS when startint the application
    @Published var globalStoreData:GlobalStoreData=load("globalStore.json")     // Global parameters;
    @Published var tasklist:[Taskstruct]=load("tasklistData.json")              // task list;
    @Published var segmentlist:[Segmentstruct]=load("segmentlistData.json")     // a task split into several segments, all segments of all tasks managed by the list;
    @Published var routinelist:[String:Daystruct]=load("routinelistData.json")  // days are filled with segments according to rules;
    
    
    // Add new task into tasklist, split it into segments and allocate them into days
    func addTask(taskName: String, deadline: Date, cost:Int, gran:Int=2, schpre:Int=1, desp:String=""){
        globalStoreData.taskCounter += 1
        var newTask = Taskstruct(taskname: taskName,deadline: deadline,estimatedCost: cost, granularity: gran, schedulePrefernece: schpre, description: desp)
        
        var segNum = cost/gran
        if gran*segNum<cost {
            segNum+=1
        }
        var haveCost = 0
        var nextGran = gran
        
        if schpre==1 { // schedule preference: as soon as possible
            let dateformatter1 = DateFormatter()
            dateformatter1.dateFormat = "yyyy-MM-dd"
            let dateformatter2 = DateFormatter()
            dateformatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let today = Date()
            let startDayStr = dateformatter1.string(from: today)
            var startDay = dateformatter1.date(from: startDayStr)
            startDay = startDay!.addingTimeInterval(TimeInterval(24*60*60))
            let endDayStr = dateformatter1.string(from: deadline)
            var endDay = dateformatter1.date(from: endDayStr)
            
            var iter_day = startDay
            /* allocate segs to the days, from tomorrow to ddl */
            while true{
                let dateStr = dateformatter1.string(from:iter_day!)
                var thisDay:Daystruct
                if routinelist[dateStr] == nil{
                    thisDay = Daystruct(date: iter_day!)
                    routinelist[dateStr] = thisDay
                }else{
                    thisDay = routinelist[dateStr]!
                }
                
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
                            globalStoreData.segmentCounter += 1
                            var newSegment = Segmentstruct(taskId: globalStoreData.taskCounter, day: iter_day!, startTime: p-gran+1, endTime: p)
                            thisDay.segmentsId.append(globalStoreData.segmentCounter)
                            newTask.segmentsId.append(globalStoreData.segmentCounter)
                            segmentlist.append(newSegment)
                            
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
            print("Successfully Allocated")
        }
        else {
            fatalError("No enough time! Allocating failed")
            // TODO: rollback operations
            // ...
        }
    }
    
    func saveData(){
        save(dir:"globalStore.json", data:globalStoreData)
        save(dir:"tasklistData.json", data:tasklist)
        save(dir:"segmentlistData.json", data: segmentlist)
        save(dir:"routinelistData.json", data:routinelist)
    }
}


// Data load and save

func load<T:Decodable>(_ filename:String)->T{
    let data: Data
    
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
