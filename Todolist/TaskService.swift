//
//  TaskService.swift
//  Todolist
//
//  Created by Arthur Mariano on 16/09/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class TaskService {
    private var db = Firestore.firestore()
    var authService: AuthService
    var tasks = [TodoTask]()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func addTask(task: TodoTask, completion: @escaping (Error?) -> Void) {
        guard let uid = authService.user?.uid else { return }
        guard let taskId = task.id else { return }
        
        do {
            let data = try Firestore.Encoder().encode(task)
            db.collection("users").document(uid).collection("tasks")
                .document(taskId)
                .setData(data) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
        } catch {
            completion(error)
        }
    }
    
    func updateTask(task: TodoTask, completion: @escaping (Error?) -> Void) {
        guard let uid = authService.user?.uid else { return }
        guard let taskId = task.id else { return }
        
        do {
            let data = try Firestore.Encoder().encode(task)
            db.collection("users").document(uid).collection("tasks")
                .document(taskId)
                .updateData(data) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    completion(nil)
                }
        } catch {
            completion(error)
        }
    }
    
    func deleteTask(taskId: String) {
        guard let uid = authService.user?.uid else { return }
        
        db.collection("users").document(uid).collection("tasks")
            .document(taskId)
            .delete()
    }

    func getTasks(completion: @escaping (Error?) -> Void) {
        guard let uid = authService.user?.uid else { return }
        
        db.collection("users").document(uid).collection("tasks").order(by: "title").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            self.tasks = snapshot?.documents.compactMap { document in
                try? document.data(as: TodoTask.self)
            } ?? []
        }
    }
}

