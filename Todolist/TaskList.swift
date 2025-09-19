import SwiftUI

import SwiftUI

struct TaskList: View {
    @Environment(NotificationService.self) private var notificationService
    @Environment(TaskService.self) private var taskService
    
    @State private var searchText: String = ""
    @State private var draftTask: TodoTask?
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        List {
            ForEach(filteredTasks) { task in
                NavigationLink {
                    TaskForm(task: binding(for: task)) {
                        Task {
                            await notificationService.scheduleNotification(for: task.dueDate, title: task.title, body: task.description, identifier: task.id)
                        }

                        taskService.updateTask(task: task) { error in
                            if let error = error {
                                showError(error)
                            }
                        }
                    }
                } label: {
                    Text(task.title)
                }
            }
            .onDelete(perform: deleteTask)
        }
        .overlay {
            if filteredTasks.isEmpty {
                ContentUnavailableView("No tasks yet", systemImage: "square.and.pencil")
                    .onTapGesture(perform: addTask)
            }
        }
        .navigationTitle("Tasks")
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            
            DefaultToolbarItem(kind: .search, placement: .bottomBar)

            ToolbarSpacer(placement: .bottomBar)

            ToolbarItem(placement: .bottomBar) {
                Button {
                    addTask()
                } label: {
                    Label("New Task", systemImage: "plus")
                }
            }
        }
        .sheet(item: $draftTask) { task in
            NavigationStack {
                TaskForm(task: bindingForDraft(task), isNew: true) {
                    Task {
                        await notificationService.scheduleNotification(for: task.dueDate, title: task.title, body: task.description, identifier: task.id)
                    }
                    
                    taskService.addTask(task: task) { error in
                        if let error = error {
                            showError(error)
                        }
                        draftTask = nil
                    }
                }
                .interactiveDismissDisabled()
            }
        }
        .onAppear {
            taskService.getTasks { error in
                if let error = error {
                    showError(error)
                }
            }
        }
        .alert("Error", isPresented: $showErrorAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text(errorMessage)
        })
    }

    private var filteredTasks: [TodoTask] {
        searchText.isEmpty
            ? taskService.tasks
            : taskService.tasks.filter { $0.title.localizedStandardContains(searchText) }
    }

    private func addTask() {
        draftTask = TodoTask(
            id: UUID().uuidString,
            title: "",
            description: "",
            completed: false,
            dueDate: .now,
            createdAt: .now,
            updatedAt: nil
        )
    }

    private func binding(for task: TodoTask) -> Binding<TodoTask> {
        Binding(
            get: {
                if let index = taskService.tasks.firstIndex(where: { $0.id == task.id }) {
                    return taskService.tasks[index]
                }
                return task
            },
            set: { newValue in
                if let index = taskService.tasks.firstIndex(where: { $0.id == task.id }) {
                    taskService.tasks[index] = newValue
                }
            }
        )
    }

    private func bindingForDraft(_ task: TodoTask) -> Binding<TodoTask> {
        Binding(
            get: { draftTask ?? task },
            set: { draftTask = $0 }
        )
    }

    private func showError(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
    
    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = filteredTasks[index]
            guard let taskId = task.id else { return }
            
            taskService.deleteTask(taskId: taskId)
        }
    }
}


#Preview {
    NavigationStack {
        TaskList()
            .environment(TaskService(authService: AuthService()))
            .environment(NotificationService())
    }
}
