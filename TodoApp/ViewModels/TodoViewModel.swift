import Foundation

// MARK: - TodoViewModel
// Uses @Observable (iOS 17+ Observation framework) instead of ObservableObject.
// This eliminates @Published boilerplate — any property mutation automatically
// triggers view updates for observing SwiftUI views.
@Observable
final class TodoViewModel {

    // MARK: - Storage

    /// The single source of truth. Every mutation flows through helper methods
    /// that call `save()` so persistence stays in sync automatically.
    var todos: [Todo] = []

    /// UserDefaults key — namespaced to avoid collisions.
    private let storageKey = "com.todoapp.todos"

    // MARK: - Computed Properties

    /// Active (incomplete) tasks sorted: high priority first, then earliest due date.
    var activeTodos: [Todo] {
        todos
            .filter { !$0.isCompleted }
            .sorted { lhs, rhs in
                // Higher priority wins; ties broken by due date (soonest first),
                // then creation date (oldest first).
                if lhs.priority != rhs.priority {
                    return lhs.priority > rhs.priority
                }
                if let lhsDue = lhs.dueDate, let rhsDue = rhs.dueDate {
                    return lhsDue < rhsDue
                }
                // Tasks WITH a due date appear before those without.
                if lhs.dueDate != nil && rhs.dueDate == nil { return true }
                if lhs.dueDate == nil && rhs.dueDate != nil { return false }
                return lhs.createdAt < rhs.createdAt
            }
    }

    /// Completed tasks in reverse-completion order aren't tracked separately,
    /// so we fall back to reverse creation date (most recent first).
    var completedTodos: [Todo] {
        todos
            .filter { $0.isCompleted }
            .sorted { $0.createdAt > $1.createdAt }
    }

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - CRUD

    func addTodo(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        let todo = Todo(title: title, priority: priority, dueDate: dueDate)
        todos.append(todo)
        save()
    }

    func toggleCompletion(for todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index].isCompleted.toggle()
        save()
    }

    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index] = todo
        save()
    }

    func deleteTodo(at offsets: IndexSet, from section: [Todo]) {
        // Map IndexSet from the *section* array back to IDs, then remove from
        // the main `todos` array. This avoids index mismatches between
        // the filtered section and the backing store.
        let idsToDelete = offsets.map { section[$0].id }
        todos.removeAll { idsToDelete.contains($0.id) }
        save()
    }

    // MARK: - Persistence

    /// Encode the full array to JSON and write to UserDefaults.
    /// Called after every mutation so data survives app termination.
    private func save() {
        guard let data = try? JSONEncoder().encode(todos) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    /// Load persisted data on init; fail silently if nothing is stored yet.
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Todo].self, from: data)
        else { return }
        todos = decoded
    }
}
