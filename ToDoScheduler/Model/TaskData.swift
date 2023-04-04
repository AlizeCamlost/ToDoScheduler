//
//  TaskData.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/4.
//

import Foundation

final class Tasks: ObservableObject{
    // TODO: load tasks
    // ...
    @Published var tasklist:[Taskstruct]?
}

func load(_ filename:String){

}
