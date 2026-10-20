import Foundation

enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    var id: String { rawValue }
}

struct AvenorTask: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var details: String = ""
    var className: String = ""
    var dueDate: Date? = nil
    var priority: TaskPriority = .medium
    var estimatedMinutes: Int = 30
    var completed: Bool = false
    var createdAt: Date = Date()
}

struct AvenorClass: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var teacher: String = ""
    var room: String = ""
}

struct AvenorEvent: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var date: Date = Date()
    var startTime: String = ""
    var endTime: String = ""
}
