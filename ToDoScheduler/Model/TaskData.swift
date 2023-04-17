//
//  TaskData.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

struct GlobalStoreData:Codable{
    //var taskCounter:Int=0
}

final class Tasks: ObservableObject{
    @Published var globalStoreData:GlobalStoreData=load("globalStore.json")
    @Published var tasklist:[Taskstruct]=load("tasklistData.json")
    @Published var segmentlist:[Segmentstruct]=load("segmentlistData.json")
    @Published var routinelist:[String:Daystruct]=load("routinelistData.json")
    
    func addTask(taskName: String, deadline: Date, cost:Int){
        //globalStoreData.taskCounter += 1
        var newTask = Taskstruct(taskname: taskName,deadline: deadline,estimatedCost: cost)
        var haveCost = 0
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let lastDay: TimeInterval = -(24*60*60)
        let curTime = Date()
        var theDay = deadline
        while theDay > curTime
        {
            let theDayStr = dateformatter.string(from: theDay)
            if(routinelist[theDayStr]==nil){
                routinelist[theDayStr]=Daystruct()
            }
            for i in 0...5{
                if(routinelist[theDayStr]!.periodEmpty[i]){
                    routinelist[theDayStr]!.periodEmpty[i]=false
                    let newSeg = Segmentstruct(taskId: tasklist.count, startTime: theDay, endTime: theDay) // TODO: mend to right intervals
                    routinelist[theDayStr]!.schedule[i]=newSeg
                    newTask.segmentsId.append(segmentlist.count)
                    segmentlist.append(newSeg)
                    haveCost+=1
                    if(haveCost==cost){
                        break
                    }
                }
            }
            if(haveCost==cost){
                break
            }
            theDay = theDay.addingTimeInterval(lastDay)
        }
        if(haveCost<cost){
            print("have no enough time!")
        }
        
        
        tasklist.append(newTask)
    }
    
    func saveData(){
        save(dir:"globalStore.json", data:globalStoreData)
        save(dir:"tasklistData.json", data:tasklist)
        save(dir:"routinelistData.json", data:routinelist)
    }
}




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
