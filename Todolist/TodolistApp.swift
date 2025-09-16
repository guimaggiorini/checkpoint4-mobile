//
//  TodolistApp.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import SwiftUI
import FIrebase

@main
struct TodolistApp: App {
    init() {
        FirebaseApp.configue()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
