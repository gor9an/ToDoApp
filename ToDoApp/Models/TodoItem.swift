//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

struct TodoItem: Equatable, Identifiable {
    // MARK: Properties
    let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    let dateOfCreation: Date
    var dateOfChange: Date?
    
    // MARK: Init
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool = false,
        dateOfCreation: Date = Date(),
        dateOfChange: Date?
    ) {
        if id == "" {
            self.id = UUID().uuidString
        } else {
            self.id = id
        }
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
        self.hexColor = hexColor
    }
    
    // MARK: Importance enum
    enum Importance: String, Equatable {
        case unimportant
        case usual
        case important
    }
}
