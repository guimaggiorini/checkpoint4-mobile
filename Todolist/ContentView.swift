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
        NavigationStack {
            if authService.isSignedIn {
                TaskList()
            } else {
                AuthView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthService())
}
