# ✅ TodoApp — SwiftUI To-Do List

A clean, production-quality To-Do List app built with **SwiftUI** and the **MVVM** architecture pattern. Designed for iOS 17+, it features smooth animations, Dark Mode support, and local data persistence — all without any external dependencies.

---

## ✨ Features

- **Add, Edit & Delete Tasks** — full CRUD with swipe-to-delete
- **Priority Levels** — Low, Medium, High with color-coded badges
- **Optional Due Dates** — with calendar picker and overdue highlighting
- **Task Completion** — animated checkbox with strikethrough styling
- **Data Persistence** — tasks saved automatically via `UserDefaults`
- **Dark Mode** — fully supported out of the box
- **Accessibility** — VoiceOver labels on all interactive elements
- **Smooth Animations** — section transitions, symbol bounce effects

---

## 🏗️ Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

```
TodoApp/
├── TodoApp.swift              # App entry point
├── Models/
│   └── Todo.swift             # Todo model & Priority enum
├── ViewModels/
│   └── TodoViewModel.swift    # Business logic & persistence
└── Views/
    ├── ContentView.swift      # Main task list (Active / Completed)
    ├── TodoRowView.swift      # Individual task row component
    └── AddEditTodoView.swift  # Dual-purpose add/edit sheet
```

| Layer         | Responsibility                                    |
|---------------|---------------------------------------------------|
| **Model**     | `Todo` struct and `Priority` enum (Codable)       |
| **ViewModel** | CRUD operations, sorting, UserDefaults persistence|
| **View**      | SwiftUI views, animations, user interaction       |

---

## 🛠️ Tech Stack

| Technology           | Usage                         |
|----------------------|-------------------------------|
| **SwiftUI**          | Declarative UI framework      |
| **@Observable**      | iOS 17 Observation framework  |
| **UserDefaults**     | Lightweight local persistence |
| **SF Symbols**       | System icons throughout       |

---

## 📋 Requirements

- **Xcode** 15.0+
- **iOS** 17.0+
- **Swift** 5.9+

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Lucifer-1907/to-do-list-in-swift.git
   ```
2. **Open in Xcode**
   ```bash
   cd to-do-list-in-swift
   open TodoApp.xcodeproj    # or open the folder in Xcode
   ```
3. **Build & Run** on a simulator or device (iOS 17+)

---

## 📸 Highlights

| Feature              | Details                                                  |
|----------------------|----------------------------------------------------------|
| 🎨 Priority badges   | Color-coded (🔵 Low · 🟠 Medium · 🔴 High)              |
| 📅 Due dates         | Optional, with graphical calendar picker                 |
| ⚡ Animations        | `.snappy` transitions, `.bounce` symbol effects          |
| ♿ Accessibility     | Combined VoiceOver labels on every row                   |
| 🌙 Dark Mode         | Native SwiftUI support, no extra configuration           |

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

> Built with ❤️ in Swift
