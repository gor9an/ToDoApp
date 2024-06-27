//
//  TodoItemViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import Foundation

class TodoItemViewModel: ObservableObject {
    @Published var task: TodoItem
    @Published var isDeadlineEnabled: Bool = false
    
    init(
        task: TodoItem = TodoItem(
            text: "",
            importance: .usual,
            deadline: nil,
            isDone: false,
            dateOfChange: nil
        )
    ) {
        self.task = task
        self.isDeadlineEnabled = task.deadline != nil
    }
    
    let manager = FileCache()
    
    func saveTodoItems() {
        manager.addNewTask(task)
    }
    
    func deleteTodoItems() {
        manager.delTask(id: task.id)
    }
    
    func toggleDeadline() {
        isDeadlineEnabled.toggle()
        if isDeadlineEnabled {
            task.deadline = Date().tomorrow
        } else {
            task.deadline = nil
        }
    }
}

