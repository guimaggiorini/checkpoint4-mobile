//
//  Task.swift
//  Todolist
//
//  Created by Ian Rossato Braga on 16/09/25.
//

import Foundation
import SwiftData

@Model
final class Task: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var taskDescription: String
    var completed: Bool
    var dueDate: Date
    var createdAt: Date
    var updatedAt: Date?
    var userId: UUID

    init(
        title: String,
        taskDescription: String,
        completed: Bool = false,
        dueDate: Date,
        createdAt: Date = .now,
        updatedAt: Date? = nil,
        userId: UUID
    ) {
        self.id = UUID()
        self.title = title
        self.taskDescription = taskDescription
        self.completed = completed
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
    }
}
