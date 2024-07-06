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
    @Published var todoItemCategory: TodoItem.Category?
    var todoItemCategories: [TodoItem.Category] = [
        .init(name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor),
        .init(name: TodoItemCategory.studyName, hexColor: TodoItemCategory.studyHexColor),
        .init(name: TodoItemCategory.hobbyName, hexColor: TodoItemCategory.hobbyHexColor),
        .init(name: TodoItemCategory.otherName, hexColor: TodoItemCategory.otherHexColor),
    ]
    
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
    
    func setCategory(category: TodoItem.Category) {
        task.category = category
    }
}

