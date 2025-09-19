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
    @State private var authService: AuthService
    @State private var taskService: TaskService
    @State private var quotesStore: QuotesStore = QuotesStore(webService: WebService())
    
    init() {
        FirebaseApp.configure()
        
        let auth = AuthService()
        _authService = State(initialValue: auth)
        _taskService = State(initialValue: TaskService(authService: auth))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authService)
                .environment(taskService)
                .environment(quotesStore)
        }
    }
}
