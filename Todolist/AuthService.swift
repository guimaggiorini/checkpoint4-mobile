//
//  AuthService.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import UIKit

enum AuthenticationError: Error {
    case runtimeError(String)
    case notNewUser
}

@Observable
class AuthService {
    var user: User? = nil
    var isSignedIn: Bool = false
    
    init() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = user != nil
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {  result, error in
            if let error = error {
                print("Sign Up Error:")
                print(error)
                completion(error)
                return
            }
            
            self.user = Auth.auth().currentUser
            self.isSignedIn = self.user != nil
            completion(nil)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign In Error: \(error.localizedDescription)")
                self.user = nil
                self.isSignedIn = false
                completion(error)
                return
            }
            
            self.user = Auth.auth().currentUser
            self.isSignedIn = self.user != nil
            completion(nil)
        }
    }
    
    func signOut() {
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
            self.user = nil
            self.isSignedIn = false
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
    
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw AuthenticationError.runtimeError("Unexpected error occurred, please retry")
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        let authResult = try await Auth.auth().signIn(with: credential)
        self.user = authResult.user
        self.isSignedIn = true
    }
}

