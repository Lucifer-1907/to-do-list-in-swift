import SwiftUI

// MARK: - AddEditTodoView
// Dual-purpose sheet: creates a new task when `todoToEdit` is nil,
// or updates an existing one when provided. This avoids duplicating
// nearly identical form UI into two separate views.
struct AddEditTodoView: View {

    var viewModel: TodoViewModel

    /// When nil → "Add" mode; when set → "Edit" mode.
    var todoToEdit: Todo?

    // Form state — initialized from `todoToEdit` in `.onAppear`.
    @State private var title: String = ""
    @State private var priority: Priority = .medium
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Calendar.current.startOfDay(for: .now).addingTimeInterval(86400)

    @Environment(\.dismiss) private var dismiss

    /// Convenience: are we editing an existing task?
    private var isEditing: Bool { todoToEdit != nil }

    var body: some View {
        NavigationStack {
            Form {
                // — Title Section —
                Section {
                    TextField("What needs to be done?", text: $title)
                        .autocorrectionDisabled(false)
                        .accessibilityLabel("Task title")
                } header: {
                    Text("Title")
                }

                // — Priority Section —
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { level in
                            Label(level.label, systemImage: level.iconName)
                                .tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("Task priority")
                } header: {
                    Text("Priority")
                }

                // — Due Date Section —
                // Toggle lets users opt in/out of a due date rather than
                // forcing them to pick one — matches Apple Reminders behavior.
                Section {
                    Toggle("Set a due date", isOn: $hasDueDate.animation())
                        .accessibilityLabel("Toggle due date")

                    if hasDueDate {
                        DatePicker(
                            "Due Date",
                            selection: $dueDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .accessibilityLabel("Select due date")
                    }
                } header: {
                    Text("Due Date")
                }
            }
            .navigationTitle(isEditing ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        saveTask()
                        dismiss()
                    }
                    // Prevent saving an empty title.
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .fontWeight(.semibold)
                }
            }
            // Populate form fields when editing an existing task.
            .onAppear {
                if let todo = todoToEdit {
                    title = todo.title
                    priority = todo.priority
                    hasDueDate = todo.dueDate != nil
                    if let date = todo.dueDate {
                        dueDate = date
                    }
                }
            }
        }
        // Constrain sheet height on iPad; full-screen on iPhone automatically.
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Save Logic

    private func saveTask() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let selectedDate = hasDueDate ? dueDate : nil

        if var existing = todoToEdit {
            // Update path — mutate a copy, then send it to the ViewModel.
            existing.title = trimmedTitle
            existing.priority = priority
            existing.dueDate = selectedDate
            viewModel.updateTodo(existing)
        } else {
            // Creation path.
            viewModel.addTodo(title: trimmedTitle, priority: priority, dueDate: selectedDate)
        }
    }
}

#Preview("Add Mode") {
    AddEditTodoView(viewModel: TodoViewModel())
}

#Preview("Edit Mode") {
    AddEditTodoView(
        viewModel: TodoViewModel(),
        todoToEdit: Todo(title: "Sample Task", priority: .high, dueDate: .now)
    )
}
