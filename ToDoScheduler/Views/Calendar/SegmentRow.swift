//
//  SegmentRow.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/24.
//

import SwiftUI

struct SegmentRow: View {
    var seg: Segmentstruct
    
    var body: some View {
        VStack {
            Text("Segment Row")
            Text("taskId:\(seg.taskId)")
            Text("date:\(seg.day)")
            Text("startTime: \(seg.startTime/2):\(seg.startTime%2*30)")
            Text("endTime: \(seg.endTime/2):\(seg.endTime%2*30+29)")
        }
    }
}

struct SegmentRow_Previews: PreviewProvider {
    static var segs = Tasks().segmentlist
    static var previews: some View {
        Group{
            SegmentRow(seg: segs[0])
            SegmentRow(seg: segs[1])
        }
    }
}
