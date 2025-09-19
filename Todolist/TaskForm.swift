//
//  TaskForm.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//


import SwiftUI

struct TaskForm: View {
    @Binding var task: TodoTask
    var isNew: Bool = false
    var onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Title", text: $task.title)
                    ZStack(alignment: .topLeading) {
                        if task.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text("Description")
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }

                        TextEditor(text: $task.description)
                            .frame(minHeight: 100)
                    }
                }
                
                Section {
                    DatePicker("Due Date", selection: $task.dueDate)
                }
                
                Section {
                    Toggle("Completed", isOn: $task.completed)
                }
                
                if !isNew {
                    Button(role: .destructive) {
                        guard let taskId = task.id else { return }
                        dismiss()
                        taskService.deleteTask(taskId: taskId)
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle(isNew ? "New Task" : "Edit Task")
        .navigationBarTitleDisplayMode(.inline)
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
    @Previewable @State var task: TodoTask = TodoTask(title: "Test", description: "Testing description!", completed: false, dueDate: .now, createdAt: .now)
    
    NavigationStack {
        TaskForm(task: $task) {
        }
        .environment(TaskService(authService: AuthService()))
    }
}
