//
//  ExtentionForUserSettingView.swift
//  ToDoScheduler
//
//  Created by Camlost 施 on 2023/4/24.
//

import Foundation
import SwiftUI
extension View {
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


