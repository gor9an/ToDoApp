//
//  TodoItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import Foundation

struct TodoItem {
    // MARK: Properties
    let id: String?
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
    enum Importance {
        case unimportant
        case usual
        case important
    }
}

// MARK: TodoItem extensions
extension TodoItem {
    var json: Any {
        let formatter = JsonDateFormatter.standard
        
        var todoItem = [
            "id": "\(id!)",
            "text": "\(text)",
            "isDone": "\(isDone)",
            "dateOfCreation": "\(formatter.string(from: dateOfCreation))"
        ] as [String : String]
        
        if importance != .usual { todoItem["importance"] = "\(importance)" }
        if let deadline { todoItem["deadline"] = formatter.string(from: deadline) }
        if let dateOfChange { todoItem["dateOfChange"] = formatter.string(from: dateOfChange) }
        
        return todoItem
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let dictionary = json as? Dictionary<String, String> else { return nil }
        
        let formatter = JsonDateFormatter.standard
        var importance: Importance = .usual
        var deadline: Date? = nil
        var dateOfCreation: Date? = nil
        var dateOfChange: Date? = nil
        
        if let importanceString = dictionary["importance"] {
            importance = importanceString ==  "important" ? Importance.important : Importance.unimportant
        }
        
        if let deadlineString = dictionary["deadline"] {
            deadline = formatter.date(from: deadlineString)
        }
        
        if let creationDateString = dictionary["dateOfCreation"] {
            dateOfCreation = formatter.date(from: creationDateString)
        }
        
        if let changeDateString = dictionary["dateOfChange"] {
            dateOfChange = formatter.date(from: changeDateString)
        }
        
        let todoItem = TodoItem(
            id: dictionary["id"],
            text: dictionary["text"] ?? "",
            importance: importance,
            deadline: deadline,
            isDone: dictionary["isDone"] == "true",
            dateOfCreation: dateOfCreation ?? Date(),
            dateOfChange: dateOfChange
        )
        
        return todoItem
    }
}
