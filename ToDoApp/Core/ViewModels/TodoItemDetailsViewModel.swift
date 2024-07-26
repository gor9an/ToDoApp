//
//  TodoItemDetailsViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import CocoaLumberjackSwift
import SwiftUI

final class TodoItemDetailsViewModel: ObservableObject {
    private let fileCache: FileCache<TodoItem>
    private let networkingService: NetworkingServiceProtocol
    @Published var task: TodoItem
    @Published var isDeadlineEnabled: Bool = false
    @Published var todoItemCategory: TodoItem.Category?
    var todoItemCategories: [TodoItem.Category] = [
        .init(name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor),
        .init(name: TodoItemCategory.studyName, hexColor: TodoItemCategory.studyHexColor),
        .init(name: TodoItemCategory.hobbyName, hexColor: TodoItemCategory.hobbyHexColor),
        .init(name: TodoItemCategory.otherName, hexColor: TodoItemCategory.otherHexColor)
    ]

    // MARK: Initialaser
    init(_ fileCache: FileCache<TodoItem>, _ networkingService: NetworkingServiceProtocol, _ task: TodoItem) {
        self.fileCache = fileCache
        self.networkingService = networkingService
        fileCache.fetchTodoItems()
        self.task = task
        if task.deadline != nil { isDeadlineEnabled = true }

    }

    func saveTask() async throws {
//        if fileCache.todoItems[task.id] != nil {
//            try await networkingService.updateItem(task)
//        } else {
//            try await networkingService.addItem(task)
//        }

        DDLogInfo("\(#fileID); \(#function)\nThe data is saved.")
    }

    @MainActor func saveToFileCache() {
        fileCache.addNewTask(task)
        fileCache.update(task)
        fileCache.saveTodoItems()
    }

    func deleteTask() async throws {
        fileCache.deleteTask(id: task.id)
        await fileCache.delete(task)
        fileCache.saveTodoItems()

//        try await networkingService.deleteItem(task.id)
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
