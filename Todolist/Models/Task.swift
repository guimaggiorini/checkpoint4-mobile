import Foundation

//
//  Task.swift
//  Todolist
//
//  Created by Ian Rossato Braga on 16/09/25.
//

struct Task: Codable {
    var title: String
    var description: String
    var completed: Bool
    var dueDate: Date
    var createdAt: Date
    var updatedAt: Date?
    var userId: UUID
}
