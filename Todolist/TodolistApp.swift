//
//  TodolistApp.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import SwiftUI
import Firebase

@main
struct TodolistApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthService())
        }
    }
}
