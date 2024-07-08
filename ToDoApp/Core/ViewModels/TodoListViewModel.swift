//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 28.06.2024.
//

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
        TodoItem(text: "", importance: .usual, deadline: nil, dateOfChange: nil, category: nil)
    }
    
    func refreshData() {
        fileCache.fetchTodoItems()
        tasks = fileCache.todoItems.map { $0.value }
        sortTasksByDeadline()
    }
    
    func save() {
        fileCache.saveTodoItems()
    }
    
    func deleteTask(task: TodoItem) {
        tasks.removeAll { $0.id == task.id }
        fileCache.deleteTask(id: task.id)
        save()
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
