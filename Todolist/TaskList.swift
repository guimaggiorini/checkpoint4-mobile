import SwiftUI

import SwiftUI

struct TaskList: View {
    @Environment(TaskService.self) private var taskService
    @State private var searchText: String = ""
    @State private var draftTask: Task?
    
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        List {
            ForEach(filteredTasks) { task in
                NavigationLink {
                    TaskForm(task: binding(for: task)) {
                        taskService.addTask(task: task) { error in
                            if let error = error {
                                showError(error)
                            }
                        }
                    }
                } label: {
                    Text(task.title)
                }
            }
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

    private var filteredTasks: [Task] {
        searchText.isEmpty
            ? taskService.tasks
            : taskService.tasks.filter { $0.title.localizedStandardContains(searchText) }
    }

    private func addTask() {
        draftTask = Task(
            id: UUID().uuidString,
            title: "",
            description: "",
            completed: false,
            dueDate: .now,
            createdAt: .now,
            updatedAt: nil
        )
    }

    private func binding(for task: Task) -> Binding<Task> {
        guard let index = taskService.tasks.firstIndex(where: { $0.id == task.id }) else {
            return .constant(task)
        }
        return Binding(
            get: { taskService.tasks[index] },
            set: { taskService.tasks[index] = $0 }
        )
    }

    private func bindingForDraft(_ task: Task) -> Binding<Task> {
        Binding(
            get: { draftTask ?? task },
            set: { draftTask = $0 }
        )
    }

    private func showError(_ error: Error) {
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}


#Preview {
    NavigationStack {
        TaskList()
            .environment(TaskService(authService: AuthService()))
    }
}
