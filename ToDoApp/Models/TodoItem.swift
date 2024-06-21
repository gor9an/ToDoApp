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

// MARK: TodoItem extensions
extension TodoItem {
    struct Constants {
        let idString = "id"
        let textString = "text"
        let importanceString = "importance"
        let deadlineString = "deadline"
        let isDoneString = "isDone"
        let dateOfCreationString = "dateOfCreation"
        let dateOfChangeString = "dateOfChange"
    }
    
    var json: Any {
        let formatter = JsonDateFormatter.standard
        let const = Constants()
        
        var todoItem: [String : Any] = [
            const.idString: id,
            const.textString: text,
            const.isDoneString: isDone,
            const.dateOfCreationString: "\(formatter.string(from: dateOfCreation))"
        ]
        
        if importance != .usual { todoItem[const.importanceString] = importance.rawValue }
        if let deadline { todoItem[const.deadlineString] = formatter.string(from: deadline) }
        if let dateOfChange { todoItem[const.dateOfChangeString] = formatter.string(from: dateOfChange) }
        
        return todoItem
    }
    
    static func parse(json: Any) -> TodoItem? {
        let const = Constants()
        let formatter = JsonDateFormatter.standard
        guard let dictionary = json as? Dictionary<String, Any>,
              let id = dictionary[const.idString] as? String,
              let text = dictionary[const.textString] as? String,
              let isDone = dictionary[const.isDoneString] as? Bool,
              let creationDateString = dictionary[const.dateOfCreationString] as? String,
              let dateOfCreation = formatter.date(from: creationDateString)
        else { return nil }
        
        var importance: Importance = .usual
        var deadline: Date? = nil
        var dateOfChange: Date? = nil
        
        if let importanceString = dictionary[const.importanceString] as? String,
           let importanceRaw = Importance(rawValue: importanceString)
        {
            importance = importanceRaw
        } else {
            importance = .usual
        }
        
        if let deadlineString = dictionary["deadline"] as? String {
            deadline = formatter.date(from: deadlineString)
        }
        
        if let changeDateString = dictionary["dateOfChange"] as? String {
            dateOfChange = formatter.date(from: changeDateString)
        }
        
        let todoItem = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            dateOfCreation: dateOfCreation,
            dateOfChange: dateOfChange
        )
        
        return todoItem
    }
}
