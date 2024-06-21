//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

struct TodoItem: Equatable {
    // MARK: Properties
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let dateOfCreation: Date
    let dateOfChange: Date?
    
    // MARK: Init
    init(
        id: String?,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        dateOfCreation: Date,
        dateOfChange: Date?
    ) {
        if let id, id != "" {
            self.id = id
        } else {
            self.id = UUID().uuidString
        }
        
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
    }
    
    // MARK: Importance enum
    enum Importance: String, Equatable {
        case unimportant
        case usual
        case important
    }
}
