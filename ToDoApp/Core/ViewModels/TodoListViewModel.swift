//
//  TodoListViewModel.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 28.06.2024.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var tasks: [TodoItem] = []
    @Published var showCompletedTasks: Bool = false
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        tasks = [
            TodoItem(text: "Купить сыр", importance: .usual, deadline: nil, isDone: false, dateOfCreation: Date(), dateOfChange: nil),
            TodoItem(text: "Сделать пиццу", importance: .important, deadline: nil, isDone: false, dateOfCreation: Date(), dateOfChange: nil),
            TodoItem(text: "Задание", importance: .usual, deadline: Date(), isDone: false, dateOfCreation: Date(), dateOfChange: nil),
        ]
    }
    var newTask: TodoItem {
        TodoItem(text: "", importance: .usual, deadline: nil, dateOfChange: nil)
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
    
    func changeTask(text: String, importance: TodoItem.Importance, deadline: Date?) {
        
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
