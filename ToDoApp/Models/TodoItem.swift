//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

struct TodoItem {
    let id: String?
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let dateOfCreation: Date
    let dateOfChange: Date?
    
    init(
        id: String?,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        dateOfCreation: Date,
        dateOfChange: Date?
    ) {
        if let id {
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
    
    enum Importance {
        case unimportant
        case usual
        case important
    }
}

//extension TodoItem {
//    static func parse(json: Any) -> TodoItem? {
//        
//    }
//}
