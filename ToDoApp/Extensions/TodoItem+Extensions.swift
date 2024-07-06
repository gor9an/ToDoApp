//
//  TodoItem+Extensions.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 22.06.2024.
//

import Foundation

extension TodoItem {
    struct Constants {
        static let idString = "id"
        static let textString = "text"
        static let importanceString = "importance"
        static let deadlineString = "deadline"
        static let isDoneString = "isDone"
        static let dateOfCreationString = "dateOfCreation"
        static let dateOfChangeString = "dateOfChange"
        static let categoryString = "category"
    }
    
    // MARK: Parsing and collecting a JSON file
    var json: Any {
        let formatter = JsonDateFormatter.standard
        
        var todoItem: [String : Any] = [
            Constants.idString: id,
            Constants.textString: text,
            Constants.isDoneString: isDone,
            Constants.dateOfCreationString: "\(formatter.string(from: dateOfCreation))"
        ]
        
        if importance != .usual { todoItem[Constants.importanceString] = importance.rawValue }
        if let deadline { todoItem[Constants.deadlineString] = formatter.string(from: deadline) }
        if let dateOfChange { todoItem[Constants.dateOfChangeString] = formatter.string(from: dateOfChange) }
        
        if let category = category {
            todoItem[Constants.categoryString] = [
                Category.PropertyName.name.rawValue: category.name,
                Category.PropertyName.hexColor.rawValue: category.hexColor
            ]
        }
        
        return todoItem
    }
    
    static func parse(json: Any) -> TodoItem? {
        let formatter = JsonDateFormatter.standard
        guard let dictionary = json as? Dictionary<String, Any>,
              let id = dictionary[Constants.idString] as? String,
              let text = dictionary[Constants.textString] as? String,
              let isDone = dictionary[Constants.isDoneString] as? Bool,
              let creationDateString = dictionary[Constants.dateOfCreationString] as? String,
              let dateOfCreation = formatter.date(from: creationDateString)
        else { return nil }
        
        var importance: Importance = .usual
        var deadline: Date? = nil
        var dateOfChange: Date? = nil
        
        if let importanceString = dictionary[Constants.importanceString] as? String,
           let importanceRaw = Importance(rawValue: importanceString)
        {
            importance = importanceRaw
        }
        
        if let deadlineString = dictionary["deadline"] as? String {
            deadline = formatter.date(from: deadlineString)
        }
        
        if let changeDateString = dictionary["dateOfChange"] as? String {
            dateOfChange = formatter.date(from: changeDateString)
        }
        
        let category: Category?
        if let categoryDict = dictionary[Constants.categoryString] as? [String: Any],
           let categoryName = categoryDict[Category.PropertyName.name.rawValue] as? String,
           let categoryHexColor = categoryDict[Category.PropertyName.hexColor.rawValue] as? String {
            category = Category(name: categoryName, hexColor: categoryHexColor)
        } else {
            category = nil
        }
        
        let todoItem = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            dateOfCreation: dateOfCreation,
            dateOfChange: dateOfChange,
            category: category
        )
        
        return todoItem
    }
}

extension TodoItem {
    // MARK: Parsing and collecting a CSV file
    var csv: String {
        let formatter = JsonDateFormatter.standard
        var importanceString = ""
        var deadlineString = ""
        var dateOfChangeString = ""
        
        if importance != .usual { importanceString = importance.rawValue }
        if let deadline { deadlineString = formatter.string(from: deadline) }
        if let dateOfChange { dateOfChangeString = formatter.string(from: dateOfChange) }
        let dateOfCreationString = formatter.string(from: dateOfCreation)
        
        return "\(id),\(text),\(importanceString),\(deadlineString),\(isDone),\(dateOfCreationString),\(dateOfChangeString),\(category?.name ?? ""),\(category?.hexColor ?? "")"
    }
    
    static func parse(csv: String) -> TodoItem? {
        let formatter = JsonDateFormatter.standard
        let values = csv.components(separatedBy: ",")
        guard values.count == 9 else { return nil }
        
        let id = values[0]
        let text = values[1]
        var importance: Importance = .usual
        if let importanceRaw = Importance(rawValue: values[2]) { importance = importanceRaw }
        let deadline = formatter.date(from: values[3])
        guard
            let isDone = Bool(values[4]),
            let dateOfCreation = formatter.date(from: values[5])
        else { return nil }
        let dateOfChange = formatter.date(from: values[6])
        let category = Category(name: values[7], hexColor: values[8])
        
        let todoItem = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            dateOfCreation: dateOfCreation,
            dateOfChange: dateOfChange,
            category: category
        )
        
        return todoItem
    }
}
