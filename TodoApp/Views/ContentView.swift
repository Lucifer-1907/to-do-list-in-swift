import SwiftUI

// MARK: - ContentView
// The root view: a sectioned list of active and completed tasks,
// with a toolbar button to add new ones.
struct ContentView: View {

    // @State works with @Observable (iOS 17+) — no @StateObject needed.
    @State private var viewModel = TodoViewModel()

    /// Controls the add/edit sheet presentation.
    @State private var showingAddSheet = false

    /// The task currently being edited; nil means "add new".
    @State private var todoToEdit: Todo?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.todos.isEmpty {
                    emptyStateView
                } else {
                    todoListView
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        todoToEdit = nil          // Ensure we're in "add" mode.
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .accessibilityLabel("Add new task")
                }
            }
            // Single sheet handles both add and edit; the presence of
            // `todoToEdit` determines which mode AddEditTodoView uses.
            .sheet(isPresented: $showingAddSheet) {
                AddEditTodoView(
                    viewModel: viewModel,
                    todoToEdit: todoToEdit
                )
            }
        }
    }

    // MARK: - Subviews

    /// Sectioned list: Active tasks on top, completed tasks collapsed below.
    private var todoListView: some View {
        List {
            // — Active Section —
            if !viewModel.activeTodos.isEmpty {
                Section {
                    ForEach(viewModel.activeTodos) { todo in
                        TodoRowView(todo: todo) {
                            withAnimation(.snappy(duration: 0.35)) {
                                viewModel.toggleCompletion(for: todo)
                            }
                        }
                        .onTapGesture {
                            todoToEdit = todo
                            showingAddSheet = true
                        }
                        // Prevent SwiftUI's default button-tap from firing
                        // alongside our onTapGesture.
                        .contentShape(Rectangle())
                    }
                    .onDelete { offsets in
                        withAnimation {
                            viewModel.deleteTodo(at: offsets, from: viewModel.activeTodos)
                        }
                    }
                } header: {
                    Text("Active")
                }
            }

            // — Completed Section —
            if !viewModel.completedTodos.isEmpty {
                Section {
                    ForEach(viewModel.completedTodos) { todo in
                        TodoRowView(todo: todo) {
                            withAnimation(.snappy(duration: 0.35)) {
                                viewModel.toggleCompletion(for: todo)
                            }
                        }
                        .onTapGesture {
                            todoToEdit = todo
                            showingAddSheet = true
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete { offsets in
                        withAnimation {
                            viewModel.deleteTodo(at: offsets, from: viewModel.completedTodos)
                        }
                    }
                } header: {
                    Text("Completed")
                }
            }
        }
        .listStyle(.insetGrouped)
        // Animate list changes (items moving between sections).
        .animation(.default, value: viewModel.todos.map(\.isCompleted))
    }

    /// Friendly empty state so the screen never feels broken on first launch.
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Tasks Yet",
            systemImage: "checklist",
            description: Text("Tap the **+** button to add your first task.")
        )
    }
}

#Preview {
    ContentView()
}
