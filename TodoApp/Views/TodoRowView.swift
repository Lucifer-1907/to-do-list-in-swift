import SwiftUI

// MARK: - TodoRowView
// A single row in the task list. Displays:
//   • Checkbox toggle (animated)
//   • Task title (with strikethrough when done)
//   • Priority badge
//   • Due date (red if overdue)
struct TodoRowView: View {

    let todo: Todo

    /// Closure instead of binding — lets the parent (ContentView) wrap the
    /// toggle in `withAnimation` for a smooth section-move transition.
    var onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // — Checkbox —
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(todo.isCompleted ? .green : .secondary)
                    // Spring keeps the check-mark lively without being distracting.
                    .symbolEffect(.bounce, value: todo.isCompleted)
            }
            .buttonStyle(.plain)
            // VoiceOver: announce action, not the raw icon name.
            .accessibilityLabel(todo.isCompleted ? "Mark incomplete" : "Mark complete")

            // — Title & metadata —
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted, color: .secondary)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                // Sub-row: priority + optional due date
                HStack(spacing: 8) {
                    priorityBadge

                    if let dueDate = todo.dueDate {
                        dueDateLabel(dueDate)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
        // Composite accessibility label so VoiceOver reads one coherent sentence.
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    // MARK: - Components

    /// Colored capsule showing priority level.
    private var priorityBadge: some View {
        Label(todo.priority.label, systemImage: todo.priority.iconName)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(priorityColor)
    }

    /// Due date with red tint when overdue.
    private func dueDateLabel(_ date: Date) -> some View {
        Label {
            Text(date, style: .date)
        } icon: {
            Image(systemName: "calendar")
        }
        .font(.caption)
        .foregroundStyle(todo.isOverdue ? .red : .secondary)
    }

    // MARK: - Helpers

    private var priorityColor: Color {
        switch todo.priority {
        case .low:    return .blue
        case .medium: return .orange
        case .high:   return .red
        }
    }

    /// Builds a human-readable string for VoiceOver.
    private var accessibilityDescription: String {
        var parts = [todo.title, "\(todo.priority.label) priority"]
        if todo.isCompleted { parts.append("completed") }
        if let dueDate = todo.dueDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            parts.append("due \(formatter.string(from: dueDate))")
            if todo.isOverdue { parts.append("overdue") }
        }
        return parts.joined(separator: ", ")
    }
}
