//
//  LoginView.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//


import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @Environment(AuthService.self) private var authService: AuthService
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorEmail: String? = nil
    @State private var errorPassword: String? = nil
    @State private var authError: String? = nil
    @State private var isLoading: Bool = false
    @State private var isPasswordVisible: Bool = false
    @FocusState private var focusedField: Field?
    
    // if I put this placeholder directly into TextField, it will turn the placeholder into a "mailto" link. this is an easy workaround that i've found.
    private var emailPlaceholder: String = "name@example.com"
    
    enum Field {
        case email
        case password
    }
    
    var isFormValid: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedEmail.isEmpty && trimmedEmail.contains("@") && password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        TextField(emailPlaceholder, text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                            .onChange(of: email) {
                                errorEmail = nil
                                authError = nil
                            }
                    }
                    .padding(12)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(borderColor(for: errorEmail), lineWidth: 1)
                    }
                    
                    if let errorEmail {
                        Label(errorEmail, systemImage: "exclamationmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .accessibilityLabel("Email error: \(errorEmail)")
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        Group {
                            if isPasswordVisible {
                                TextField("At least 6 characters", text: $password)
                                    .textContentType(.password)
                                    .onChange(of: password) {
                                        errorPassword = nil
                                        authError = nil
                                    }
                            } else {
                                SecureField("At least 6 characters", text: $password)
                                    .textContentType(.password)
                                    .onChange(of: password) {
                                        errorPassword = nil
                                        authError = nil
                                    }
                            }
                        }
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            if isFormValid && !isLoading {
                                handleLogin()
                            }
                        }
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isPasswordVisible.toggle()
                            }
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .contentShape(Rectangle())
                                .accessibilityLabel(isPasswordVisible ? "Hide password" : "Show password")
                        }
                    }
                    .padding(12)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(borderColor(for: errorPassword), lineWidth: 1)
                    }
                    
                    if let errorPassword {
                        Label(errorPassword, systemImage: "exclamationmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .accessibilityLabel("Password error: \(errorPassword)")
                    }
                }
            }
            .padding(.top, 4)
            
            if let authError {
                Label(authError, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .padding(.top, 4)
                    .accessibilityLabel("Authentication error: \(authError)")
            }
            
            VStack(spacing: 10) {
                Button(action: handleLogin) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "arrow.right.circle.fill")
                        }
                        Text("Join")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(7)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
                .accessibilityHint("Login with email and password")
                
                Button(action: signInWithGoogle) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image("google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                        }
                        Text("Sign in with Google")
                            .bold()
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.black, lineWidth: 1)
                }
                .disabled(isLoading)
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
                .accessibilityHint("Sign in with Google")
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 20)
        
    }
    
    private func signInWithGoogle() {
        Task {
            do {
                try await authService.signInWithGoogle()
            } catch {
                print("An unexpected error occurred while signing in with Google.")
            }
        }
    }
    
    private func borderColor(for error: String?) -> Color {
        if error != nil {
            return .red
        } else {
            return Color(.separator)
        }
    }
    
    private func validateEmail() {
        authError = nil
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            errorEmail = "Email is required."
        } else if !trimmed.contains("@") {
            errorEmail = "Use a valid email."
        } else {
            errorEmail = nil
        }
    }
    
    private func validatePassword() {
        authError = nil
        if password.isEmpty {
            errorPassword = "Password is required."
        } else if password.count < 6 {
            errorPassword = "Password must have at least 6 characters."
        } else {
            errorPassword = nil
        }
    }
    
    private func handleLogin() {
        authError = nil
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            errorEmail = "Email is required."
            focusedField = .email
            return
        }
        if !trimmedEmail.contains("@") {
            errorEmail = "Use a valid email."
            focusedField = .email
            return
        }
        if password.isEmpty {
            errorPassword = "Password is required."
            focusedField = .password
            return
        }
        if password.count < 6 {
            errorPassword = "Password must have at least 6 characters."
            focusedField = .password
            return
        }
        
        isLoading = true
        authService.signIn(email: trimmedEmail, password: password) { error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    authError = mapAuthError(error)
                } else {
                    errorEmail = nil
                    errorPassword = nil
                    authError = nil
                    focusedField = nil
                }
            }
        }
    }
    
    private func mapAuthError(_ error: Error) -> String {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return "Connection failed. Please try again later."
        }
        return "Incorrect credentials."
    }
}

#Preview {
    LoginView()
        .environment(AuthService())
}
