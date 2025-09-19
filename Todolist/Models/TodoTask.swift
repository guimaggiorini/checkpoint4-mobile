//
//  Task.swift
//  Todolist
//
//  Created by Ian Rossato Braga on 16/09/25.
//

import Foundation
import FirebaseFirestore

struct TodoTask: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var completed: Bool
    var dueDate: Date
    var createdAt: Date
    var updatedAt: Date?
}
