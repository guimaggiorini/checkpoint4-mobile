//
//  TaskForm.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//


import SwiftUI

struct TaskForm: View {
    @Bindable var task: Task
    var isNew: Bool = false
    var onSave: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Title", text: $task.title)
            TextField("Description", text: $task.taskDescription)
            DatePicker("Due Date", selection: $task.dueDate)
            Toggle("Completed", isOn: $task.completed)
        }
        .navigationTitle(isNew ? "New Task" : "Edit Task")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave?()
                    dismiss()
                }
            }
            isNew ? ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            } : nil
        }
    }
}
