//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

struct TodoItem: Equatable, Identifiable, FileCacheItem {
    // MARK: Properties
    let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    let dateOfCreation: Date
    var dateOfChange: Date?
    var category: Category?

    // MARK: Init
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool = false,
        dateOfCreation: Date = Date(),
        dateOfChange: Date?,
        category: Category?
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
        self.category = category
    }

    // MARK: Importance enum
    enum Importance: String, Equatable, Codable {
        case low
        case basic
        case important
    }

    struct Category: Identifiable, Hashable, Codable {
        var id: String
        let name: String
        let hexColor: String?

        init(id: String = UUID().uuidString, name: String, hexColor: String?) {
            self.id = id
            self.name = name
            self.hexColor = hexColor
        }

        enum PropertyName: String {
            case name
            case hexColor
        }
    }
}
