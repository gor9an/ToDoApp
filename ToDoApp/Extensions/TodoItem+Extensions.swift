//
//  TodoItem+Extensions.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 22.06.2024.
//

import Foundation

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
    
    // MARK: Parsing and collecting a JSON file
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

extension TodoItem {
    // MARK: Parsing and collecting a CSV file
    static func converToCsv(todoItems: [TodoItem]) -> String {
        let formatter = JsonDateFormatter.standard
        var result = ""
        
        for item in todoItems {
            var line = ""
            let itemMirror = Mirror(reflecting: item)
            
            for (_, value) in itemMirror.children {
                if let stringValue = value as? String {
                    line += "\(stringValue)"
                } else if let boolValue = value as? Bool {
                    line += "\(boolValue)"
                } else if let dateValue = value as? Date {
                    line += "\(formatter.string(from: dateValue))"
                } else if let importanceValue = value as? Importance {
                    line += "\(importanceValue.rawValue)"
                }
                
                line += ","
            }
            
            result.append(line)
            result.removeLast()
            result.append("\n")
        }
        
        return result
    }
    
    static func parse(csv: String) -> [TodoItem]? {
        let formatter = JsonDateFormatter.standard
        let lines = csv.split(separator: "\n").map { "\($0)" }
        var todoItems = [TodoItem]()
        
        for line in lines {
            let values = line.components(separatedBy: ",")
            if values.count != 7 {
                continue
            }
            
            
            let id = values[0]
            let text = values[1]
            var importance: Importance = .usual
            let dateOfChange = formatter.date(from: values[6])
            let deadline = formatter.date(from: values[3])
            
            if let importanceRaw = Importance(rawValue: values[2]) {
                importance = importanceRaw
            }
            
            guard 
                let isDone = Bool(values[4]),
                let dateOfCreation = formatter.date(from: values[5])
            else { return nil }
            
            let todoItem = TodoItem(
                id: id,
                text: text,
                importance: importance,
                deadline: deadline,
                isDone: isDone,
                dateOfCreation: dateOfCreation,
                dateOfChange: dateOfChange
            )
            
            todoItems.append(todoItem)
        }
        
        return todoItems
    }
}
