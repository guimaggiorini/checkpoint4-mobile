//
//  TaskList.swift
//  Todolist
//
//  Created by Gui Maggiorini on 16/09/25.
//

import SwiftData
import SwiftUI

struct TaskList: View {
    @State private var searchText = ""
    @Query(sort: \Task.dueDate) private var tasks: [Task]
    @Environment(\.modelContext) private var context
    @State private var newTask: Task?

    var filteredTasks: [Task] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { $0.title.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        Group {
            if !filteredTasks.isEmpty {
                List {
                    ForEach(filteredTasks) { task in
                        NavigationLink(task.title) {
                            TaskForm(task: task)
                        }
                    }
                    .onDelete(perform: deleteTasks(indexes:))
                }
            } else {
                ContentUnavailableView("Add tasks", systemImage: "long.text.page.and.pencil.fill")
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem {
                Button("Create task", systemImage: "plus", action: addTask)
            }
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .sheet(item: $newTask) { task in
            NavigationStack {
                TaskForm(task: task, isNew: true, onSave: { newTask = nil })
            }
            .interactiveDismissDisabled()
        }
        .searchable(text: $searchText, prompt: "Search tasks")
    }

    private func addTask() {
        let task = Task(
            title: "",
            taskDescription: "",
            dueDate: .now,
            userId: UUID()
        )
        context.insert(task)
        newTask = task
    }

    private func deleteTasks(indexes: IndexSet) {
        for index in indexes {
            context.delete(filteredTasks[index])
        }
    }
}

#Preview {
    NavigationStack {
        TaskList()
            .modelContainer(for: Task.self, inMemory: true)
    }
}
