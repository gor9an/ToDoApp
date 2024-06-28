//
//  TodoItemDetailsViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import Foundation

class TodoItemDetailsViewModel: ObservableObject {
    @Published var task: TodoItem
    @Published var isDeadlineEnabled: Bool = false
    private var todoListViewModel: TodoListViewModel
    
    init(task: TodoItem, todoListViewModel: TodoListViewModel) {
        self.task = task
        self.todoListViewModel = todoListViewModel
        
        self.isDeadlineEnabled = task.deadline != nil
    }
    
    
    func saveTask() {
        if let index = todoListViewModel.tasks.firstIndex(where: { $0.id == task.id }) {
            todoListViewModel.tasks[index] = task
        } else {
            todoListViewModel.tasks.append(task)
        }
    }
    
    func deleteTask() {
        todoListViewModel.tasks.removeAll { $0.id == task.id }
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

