import SwiftUI

// MARK: - App Entry Point
// The @main attribute tells Swift this is the single entry point.
// ContentView creates and owns the TodoViewModel via @State,
// so there's no need to inject it here.
@main
struct TodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
