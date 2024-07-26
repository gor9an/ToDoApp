//
//  SwiftDataItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.07.2024.
//

import Foundation
import SwiftData

@Model
final class SwiftDataItem: Identifiable {
    let id: String
    var text: String
    var importance: TodoItem.Importance
    var deadline: Date?
    var isDone: Bool
    let dateOfCreation: Date
    var dateOfChange: Date?
    var category: TodoItem.Category?

    init(
        id: String = UUID().uuidString,
        text: String = "",
        importance: TodoItem.Importance = .basic,
        deadline: Date?,
        isDone: Bool = false,
        dateOfCreation: Date = .now,
        dateOfChange: Date? = Date(),
        category: TodoItem.Category?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
        self.category = category
    }

    static func toSwiftDataItem(_ todoItem: TodoItem) -> SwiftDataItem {
        SwiftDataItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isDone: todoItem.isDone,
            dateOfCreation: todoItem.dateOfCreation,
            dateOfChange: todoItem.dateOfChange,
            category: todoItem.category
        )
    }

    static func toTodoItem(_ swiftDataItem: SwiftDataItem) -> TodoItem {
        TodoItem(
            id: swiftDataItem.id,
            text: swiftDataItem.text,
            importance: swiftDataItem.importance,
            deadline: swiftDataItem.deadline,
            isDone: swiftDataItem.isDone,
            dateOfCreation: swiftDataItem.dateOfCreation,
            dateOfChange: swiftDataItem.dateOfChange,
            category: swiftDataItem.category
        )
    }
}
