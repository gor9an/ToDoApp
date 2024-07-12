//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 28.06.2024.
//

import CocoaLumberjackSwift
import SwiftUI

final class TodoListViewModel: ObservableObject {
    var fileCache = FileCache()
    @Published var tasks: [TodoItem] = []
    @Published var showCompletedTasks: Bool = false

    init() {
        fileCache.fetchTodoItems()
        tasks = fileCache.todoItems.map { $0.value }
        sortTasksByDeadline()
    }

    var newTask: TodoItem {
        let item = TodoItem(
            text: "",
            importance: .usual,
            deadline: nil,
            dateOfChange: nil,
            category: nil
        )

        DDLogInfo("\(#fileID); \(#function)\nCreate new TodoItem with id:\(item.id).")
        return item
    }

    func refreshData() {
        fileCache.fetchTodoItems()
        tasks = fileCache.todoItems.map { $0.value }
        sortTasksByDeadline()

        DDLogInfo("\(#fileID); \(#function)\nUpdated data.")
    }

    func save() {
        fileCache.saveTodoItems()
        DDLogInfo("\(#fileID); \(#function)\nThe data is saved.")
    }

    func deleteTask(task: TodoItem) {
        tasks.removeAll { $0.id == task.id }
        fileCache.deleteTask(id: task.id)
        save()

        DDLogInfo("\(#fileID); \(#function)\nDelete TodoItem with id:\(task.id).")
    }

    func toggleTaskCompletion(task: TodoItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
            fileCache.addNewTask(tasks[index])
            save()
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
