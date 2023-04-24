//
//  CalendarViewFromVC.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/25.
//

import SwiftUI

struct CView: View {
    var body: some View{
        VStack{
            CustomUikitTabview()
        }
    }
}

struct CustomUikitTabview: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ViewController1111
    
    func makeUIViewController(context: Context) -> ViewController1111 {
        let viewcontroll = UIStoryboard(name:"Storyboard", bundle: nil).instantiateViewController(withIdentifier: "sss") as! ViewController1111
        return viewcontroll
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct CView_Previews: PreviewProvider {
    static var previews: some View {
        CView()
    }
}

//struct ViewControllerWrapper: UIViewControllerRepresentable {
//    typealias UIViewControllerType = ViewController
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper>) -> ViewControllerWrapper.UIViewControllerType {
//        return ViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: ViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerWrapper>) {
//        //
//    }
//}
//
//struct CalendarViewFromVC: View {
//    var body: some View {
//        ViewControllerWrapper()
//    }
//}
//
//struct CalendarViewFromVC_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarViewFromVC()
//    }
//}
