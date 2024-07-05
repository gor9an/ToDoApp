//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 28.06.2024.
//

import Foundation
import SwiftUI

class TodoListViewModel: ObservableObject {
    var fileCache = FileCache()
    @Published var tasks: [TodoItem] = []
    @Published var showCompletedTasks: Bool = false
    
    init() {
        fileCache.fetchTodoItems()
        self.tasks = fileCache.todoItems.map { $0.value }
    }
    
    var newTask: TodoItem {
        TodoItem(text: "", importance: .usual, deadline: nil, dateOfChange: nil)
    }
    
    func refreshData() {
        fileCache.fetchTodoItems()
        self.tasks = fileCache.todoItems.map { $0.value }
    }
    
    func fetchItems() {
        fileCache.fetchTodoItems()
        tasks = fileCache.todoItems.map { $0.value }
    }
    
    func save() {
        fileCache.saveTodoItems()
    }
    
    func addTask(text: String, importance: TodoItem.Importance, deadline: Date?) {
        let newTask = TodoItem(
            text: text,
            importance: importance,
            deadline: deadline,
            dateOfChange: nil
        )
        tasks.append(newTask)
    }
    
    func deleteTask(task: TodoItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func toggleTaskCompletion(task: TodoItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }
    
    var filteredTasks: [TodoItem] {
        tasks.filter { showCompletedTasks || !$0.isDone }
    }
    
    func toggleShowCompletedTasks() {
        showCompletedTasks.toggle()
    }
}
