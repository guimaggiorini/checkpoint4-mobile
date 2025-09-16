//
//  AuthService.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import Foundation
import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var user: User? = nil
    @Published var isSignedIn: Bool = false
    
    init() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = user != nil
    }
    
    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {  result, error in
            if let error = error {
                print("Sign Up Error: \(error.localizedDescription)")
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
            try Auth.auth().signOut()
            self.user = nil
            self.isSignedIn = false
        } catch {
            print("Sign Out Error: \(error.localizedDescription)")
        }
    }
}
