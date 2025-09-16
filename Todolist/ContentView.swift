//
//  ContentView.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AuthService.self) private var authService: AuthService
    
    var body: some View {
        if authService.isSignedIn {
            TaskList()
                .modelContainer(for: Task.self, inMemory: true)
        } else {
            AuthView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthService())
}
