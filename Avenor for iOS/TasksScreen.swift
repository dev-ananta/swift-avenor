import SwiftUI

enum TaskFilter: String, CaseIterable { case all = "All", active = "Active", completed = "Completed" }

struct TasksScreen: View {
    @EnvironmentObject private var store: AvenorStore
    @State private var filter: TaskFilter = .all
    @State private var showingForm = false
    @State private var taskPendingDeletion: AvenorTask?
    @State private var showingDeleteConfirmation = false
    private var filtered: [AvenorTask] {
        switch filter {
        case .all: return store.tasks
        case .active: return store.tasks.filter { !$0.completed }
        case .completed: return store.tasks.filter(\.completed)
        }
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ScreenTitle(title: "Tasks", subtitle: "\(store.tasks.filter { !$0.completed }.count) active tasks")
                    Picker("Task filter", selection: $filter) {
                        ForEach(TaskFilter.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }.pickerStyle(.segmented)
                    if filtered.isEmpty {
                        Panel { VStack(alignment: .leading, spacing: 8) {
                            Text("Nothing here yet").font(.headline)
                            Text("Add a task or switch filters to see your work.").foregroundStyle(AvenorTheme.muted)
                        }}
                    } else {
                        ForEach(filtered) { task in
                            Panel {
                                HStack(alignment: .top, spacing: 12) {
                                    Button { store.toggle(task) } label: {
                                        Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                            .font(.title2).foregroundStyle(task.completed ? AvenorTheme.green : AvenorTheme.muted)
                                    }.buttonStyle(.plain).accessibilityLabel(task.completed ? "Mark incomplete" : "Mark complete")
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(task.title).font(.headline).strikethrough(task.completed)
                                        if !task.details.isEmpty { Text(task.details).font(.subheadline).foregroundStyle(AvenorTheme.muted) }
                                        HStack(spacing: 8) {
                                            Text(task.priority.rawValue).foregroundStyle(task.priority == .high ? AvenorTheme.red : task.priority == .medium ? AvenorTheme.orange : AvenorTheme.green)
                                            Text("· \(task.estimatedMinutes) min").foregroundStyle(AvenorTheme.muted)
                                        }.font(.caption)
                                        if !task.className.isEmpty { Text(task.className).font(.caption).foregroundStyle(AvenorTheme.muted) }
                                        if let due = task.dueDate { Text(due.formatted(date: .abbreviated, time: .omitted)).font(.caption).foregroundStyle(AvenorTheme.muted) }
                                    }
                                    Spacer(minLength: 0)
                                    Button(role: .destructive) {
                                        taskPendingDeletion = task
                                        showingDeleteConfirmation = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.body)
                                            .foregroundStyle(AvenorTheme.red)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("Delete task \(task.title)")
                                }
                            }
                        }
                    }
                }.padding(20)
            }
            .background(AvenorTheme.background.ignoresSafeArea())
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { showingForm = true } label: { Image(systemName: "plus") }.accessibilityLabel("Create task") } }
            .sheet(isPresented: $showingForm) { CreateTaskSheet() }
            .alert("Delete task permanently?", isPresented: $showingDeleteConfirmation, presenting: taskPendingDeletion) { task in
                Button("Delete Permanently", role: .destructive) {
                    store.deleteTask(id: task.id)
                    taskPendingDeletion = nil
                }
                Button("Cancel", role: .cancel) {
                    taskPendingDeletion = nil
                }
            } message: { task in
                Text("“\(task.title)” will be removed from Avenor and cannot be recovered.")
            }
        }
    }
}

struct CreateTaskSheet: View {
    @EnvironmentObject private var store: AvenorStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var details = ""
    @State private var className = ""
    @State private var priority: TaskPriority = .medium
    @State private var minutes = 30
    @State private var hasDueDate = false
    @State private var dueDate = Date()
    @State private var error = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Title (required)", text: $title)
                    TextField("Description", text: $details, axis: .vertical)
                    TextField("Class", text: $className)
                    Picker("Priority", selection: $priority) { ForEach(TaskPriority.allCases) { Text($0.rawValue).tag($0) } }
                    Stepper("Estimated time: \(minutes) min", value: $minutes, in: 5...600, step: 5)
                    Toggle("Set due date", isOn: $hasDueDate)
                    if hasDueDate { DatePicker("Due date", selection: $dueDate, displayedComponents: .date) }
                }
                if !error.isEmpty { Text(error).foregroundStyle(.red) }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save") { save() } }
            }
        }.presentationDetents([.medium, .large])
    }
    private func save() {
        let clean = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { error = "Enter a task title."; return }
        store.addTask(AvenorTask(title: clean, details: details, className: className, dueDate: hasDueDate ? dueDate : nil, priority: priority, estimatedMinutes: minutes))
        dismiss()
    }
}
