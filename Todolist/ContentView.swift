//
//  ContentView.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authService = AuthService()
    
    var body: some View {
        AuthView()
            .environmentObject(authService)
    }
}

#Preview {
    ContentView()
}
