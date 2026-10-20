import Foundation
import Combine

@MainActor
final class AvenorStore: ObservableObject {
    @Published var tasks: [AvenorTask] = [] { didSet { save(tasks, key: "tasks") } }
    @Published var classes: [AvenorClass] = [] { didSet { save(classes, key: "classes") } }
    @Published var events: [AvenorEvent] = [] { didSet { save(events, key: "events") } }

    init() {
        tasks = load([AvenorTask].self, key: "tasks") ?? []
        classes = load([AvenorClass].self, key: "classes") ?? []
        events = load([AvenorEvent].self, key: "events") ?? []
    }

    func addTask(_ task: AvenorTask) { tasks.insert(task, at: 0) }
    /// Permanently removes a task and immediately persists the updated task list.
    func deleteTask(id: UUID) { tasks.removeAll { $0.id == id } }
    func toggle(_ task: AvenorTask) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[i].completed.toggle()
    }
    func addClass(_ item: AvenorClass) { classes.append(item) }
    func addEvent(_ item: AvenorEvent) { events.append(item) }
    /// Permanently removes an event and immediately persists the updated event list.
    func deleteEvent(id: UUID) { events.removeAll { $0.id == id } }

    private func save<T: Encodable>(_ value: T, key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: "avenor.\(key)")
    }

    private func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: "avenor.\(key)") else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
