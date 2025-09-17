//
//  TaskForm.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//


import SwiftUI

struct TaskForm: View {
    @Binding var task: Task
    var isNew: Bool = false
    var onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Title", text: $task.title)
            TextField("Description", text: $task.description)
            DatePicker("Due Date", selection: $task.dueDate)
            Toggle("Completed", isOn: $task.completed)
        }
        .navigationTitle(isNew ? "New Task" : "Edit Task")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    onSave()
                    dismiss()
                } label: {
                    Label("Save", systemImage: "checkmark")
                }
                .disabled(task.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            if isNew {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var task: Task = Task(title: "Test", description: "Testing description!", completed: false, dueDate: .now, createdAt: .now)
    
    NavigationStack {
        TaskForm(task: $task) {
        }
    }
}
