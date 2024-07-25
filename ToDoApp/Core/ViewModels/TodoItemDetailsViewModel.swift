//
//  TodoItemDetailsViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import CocoaLumberjackSwift
import SwiftUI

final class TodoItemDetailsViewModel: ObservableObject {
    var fileCache = FileCache<TodoItem>()
    @Published var task: TodoItem
    @Published var isDeadlineEnabled: Bool = false
    @Published var todoItemCategory: TodoItem.Category?
    var todoItemCategories: [TodoItem.Category] = [
        .init(name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor),
        .init(name: TodoItemCategory.studyName, hexColor: TodoItemCategory.studyHexColor),
        .init(name: TodoItemCategory.hobbyName, hexColor: TodoItemCategory.hobbyHexColor),
        .init(name: TodoItemCategory.otherName, hexColor: TodoItemCategory.otherHexColor)
    ]

    init(task: TodoItem) {
        fileCache.fetchTodoItems()
        self.task = task
        if task.deadline != nil { isDeadlineEnabled = true }

    }

    func saveTask() async throws {
        if fileCache.todoItems[task.id] != nil {
            try await DefaultNetworkingService.shared.updateItem(task)
        } else {
            try await DefaultNetworkingService.shared.addItem(task)
        }

        DDLogInfo("\(#fileID); \(#function)\nThe data is saved.")
    }

    func saveToFileCache() {
        fileCache.addNewTask(task)
        fileCache.saveTodoItems()
    }

    func deleteTask() async throws {
        fileCache.deleteTask(id: task.id)
        fileCache.saveTodoItems()

        try await DefaultNetworkingService.shared.deleteItem(task.id)
        DDLogInfo("\(#fileID); \(#function)\nDelete TodoItem with id:\(task.id).")
    }

    func toggleDeadline() {
        isDeadlineEnabled.toggle()
        if isDeadlineEnabled {
            task.deadline = Date().tomorrow
        } else {
            task.deadline = nil
        }
    }

    func setImportance(importance: TodoItem.Importance) {
        task.importance = importance
    }

    func setDeadline(deadline: Date?) {
        task.deadline = deadline
    }

    func setCategory(category: TodoItem.Category) {
        task.category = category
    }
}
