//
//  TodoItemDetailsViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import Foundation
import SwiftUI

class TodoItemDetailsViewModel: ObservableObject {
    var fileCache = FileCache()
    @Published var task: TodoItem
    @Published var isDeadlineEnabled: Bool = false
    
    init(task: TodoItem) {
        self.task = task
        fileCache.fetchTodoItems()
    }
    
    
    func saveTask() {
        fileCache.addNewTask(task)
        fileCache.saveTodoItems()
    }
    
    func deleteTask() {
        fileCache.deleteTask(id: task.id)
        fileCache.saveTodoItems()
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
}

