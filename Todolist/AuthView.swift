//
//  AuthView.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import SwiftUI

struct AuthView: View {
    @Environment(AuthService.self) private var authService: AuthService
    
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 8) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 4)
                
                Text("Motivational frase here")
                    .font(.body)
                    .foregroundColor(.gray)
                    .italic()
            }
            .padding()
            
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Sign In") {
                    authService.signUp(email: email, password: password) { error in
                    }
                }
            }
        }
    }
}

#Preview {
    AuthView()
        .environment(AuthService())
}
