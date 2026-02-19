import Foundation

// MARK: - Priority Enum
// Separate enum keeps priority logic (colors, icons, sort weight) out of the model,
// while still being encodable for UserDefaults persistence.
enum Priority: Int, Codable, CaseIterable, Comparable {
    case low = 0
    case medium = 1
    case high = 2

    var label: String {
        switch self {
        case .low:    return "Low"
        case .medium: return "Medium"
        case .high:   return "High"
        }
    }

    /// SF Symbol name — used in both the row badge and the picker.
    var iconName: String {
        switch self {
        case .low:    return "arrow.down.circle"
        case .medium: return "equal.circle"
        case .high:   return "exclamationmark.circle"
        }
    }

    // Comparable conformance lets us sort by raw value (low → high).
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Todo Model
// Identifiable for ForEach rendering; Codable for JSON ↔ UserDefaults round-trips.
struct Todo: Identifiable, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?
    var priority: Priority

    // Default values keep call-sites clean — only title is truly required.
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = .now,
        dueDate: Date? = nil,
        priority: Priority = .medium
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.priority = priority
    }

    /// Whether the task's due date has passed without being completed.
    var isOverdue: Bool {
        guard let dueDate, !isCompleted else { return false }
        return dueDate < .now
    }
}
