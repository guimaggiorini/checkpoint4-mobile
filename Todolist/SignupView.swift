//
//  SignupView.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//

import SwiftUI

struct SignupView: View {
    @Environment(AuthService.self) private var authService: AuthService
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var errorEmail: String? = nil
    @State private var errorPassword: String? = nil
    @State private var errorConfirmPassword: String? = nil
    @State private var authError: String? = nil
    
    @State private var isLoading: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @FocusState private var focusedField: Field?
    
    // if I put this placeholder directly into TextField, it will turn the placeholder into a "mailto" link. this is an easy workaround that i've found.
    private var emailPlaceholder: String = "name@example.com"
    
    enum Field {
        case email
        case password
        case confirmPassword
    }
    
    var isFormValid: Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedEmail.isEmpty
        && trimmedEmail.contains("@")
        && password.count >= 6
        && confirmPassword == password
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
                                    .textContentType(.newPassword)
                                    .onChange(of: password) {
                                        errorPassword = nil
                                        authError = nil
                                        if !confirmPassword.isEmpty {
                                            errorConfirmPassword = nil
                                        }
                                    }
                            } else {
                                SecureField("At least 6 characters", text: $password)
                                    .textContentType(.newPassword)
                                    .onChange(of: password) {
                                        errorPassword = nil
                                        authError = nil
                                        if !confirmPassword.isEmpty {
                                            errorConfirmPassword = nil
                                        }
                                    }
                            }
                        }
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .confirmPassword
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
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Confirm password")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        Group {
                            if isConfirmPasswordVisible {
                                TextField("Repeat your password", text: $confirmPassword)
                                    .textContentType(.newPassword)
                                    .onChange(of: confirmPassword) {
                                        errorConfirmPassword = nil
                                        authError = nil
                                    }
                            } else {
                                SecureField("Repeat your password", text: $confirmPassword)
                                    .textContentType(.newPassword)
                                    .onChange(of: confirmPassword) {
                                        errorConfirmPassword = nil
                                        authError = nil
                                    }
                            }
                        }
                        .focused($focusedField, equals: .confirmPassword)
                        .submitLabel(.go)
                        .onSubmit {
                            if isFormValid && !isLoading {
                                handleSignup()
                            }
                        }
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isConfirmPasswordVisible.toggle()
                            }
                        } label: {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .contentShape(Rectangle())
                                .accessibilityLabel(isConfirmPasswordVisible ? "Hide confirm password" : "Show confirm password")
                        }
                    }
                    .padding(12)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(borderColor(for: errorConfirmPassword), lineWidth: 1)
                    }
                    
                    if let errorConfirmPassword {
                        Label(errorConfirmPassword, systemImage: "exclamationmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .accessibilityLabel("Confirm password error: \(errorConfirmPassword)")
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
                Button(action: handleSignup) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        Text("Create account")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(isLoading)
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
                .accessibilityHint("Sign up with email and password")
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 20)
        
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
    
    private func validateConfirmPassword() {
        authError = nil
        if confirmPassword.isEmpty {
            errorConfirmPassword = "Please confirm your password."
        } else if confirmPassword != password {
            errorConfirmPassword = "Passwords do not match."
        } else {
            errorConfirmPassword = nil
        }
    }
    
    private func handleSignup() {
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
        
        if confirmPassword.isEmpty {
            errorConfirmPassword = "Please confirm your password."
            focusedField = .confirmPassword
            return
        }
        if confirmPassword != password {
            errorConfirmPassword = "Passwords do not match."
            focusedField = .confirmPassword
            return
        }
        
        isLoading = true
        authService.signUp(email: trimmedEmail, password: password) { error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    authError = mapAuthError(error)
                } else {
                    errorEmail = nil
                    errorPassword = nil
                    errorConfirmPassword = nil
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
        return "Could not create your account."
    }
}

#Preview {
    SignupView()
        .environment(AuthService())
}
