//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 28.06.2024.
//

import CocoaLumberjackSwift
import SwiftUI
import TodoItemsFileCache

final class TodoListViewModel: ObservableObject {
    let fileCache = FileCache<TodoItem>()
    let testLoader = TestLoader()
    @Published var tasks: [TodoItem] = []
    @Published var showCompletedTasks: Bool = false

    var newTask: TodoItem {
        let item = TodoItem(
            text: "",
            importance: .basic,
            deadline: nil,
            dateOfChange: nil,
            category: nil
        )

        DDLogInfo("\(#fileID); \(#function)\nCreate new TodoItem with id:\(item.id).")
        return item
    }

    func updateTasks() {
        tasks = fileCache.todoItems.map { $0.value }
    }

    func saveToFileCache() {
        fileCache.saveTodoItems()
    }

    func refreshData() async throws {
        fileCache.todoItems = try await DefaultNetworkingService.shared.getList()
        ?? fileCache.todoItems

        DDLogInfo("\(#fileID); \(#function)\nUpdated data.")
    }

    func save() async throws {
        fileCache.todoItems = try await DefaultNetworkingService.shared.updateList(fileCache.todoItems)
        ?? [String: TodoItem]()

        DDLogInfo("\(#fileID); \(#function)\nThe data is saved.")
    }

    func saveItem(_ task: TodoItem) async throws {
        var newTask = task
        newTask.isDone.toggle()
        try await DefaultNetworkingService.shared.updateItem(newTask)
        try await refreshData()
    }

    func deleteTask(task: TodoItem) {
        tasks.removeAll { $0.id == task.id }
    }

    func performDelete(task: TodoItem) async throws {
        try await DefaultNetworkingService.shared.deleteItem(task.id)
        fileCache.deleteTask(id: task.id)

        try await save()

        DDLogInfo("\(#fileID); \(#function)\nDelete TodoItem with id:\(task.id).")
    }

    func toggleTaskCompletion(task: TodoItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
            fileCache.addNewTask(tasks[index])
        }
    }

    var filteredTasks: [TodoItem] {
        tasks.filter { showCompletedTasks || !$0.isDone }
    }

    func sortTasksByDeadline() {
        tasks.sort(by: {
            guard let first = $0.deadline else {
                return false
            }
            guard let second = $1.deadline else {
                return true
            }

            return first < second
        })
    }

    func toggleShowCompletedTasks() {
        showCompletedTasks.toggle()
    }
}
