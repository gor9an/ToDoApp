//
//  TodoItemTests.swift
//  ToDoAppTests
//
//  Created by Andrey Gordienko on 19.06.2024.
//
@testable import ToDoApp
import Foundation
import XCTest

final class TodoItemTests: XCTestCase {
    func testCreatingJsonDictionary() {
        //given
        let formatter = JsonDateFormatter.standard
        let someDate = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .important,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate,
            category: TodoItem.Category(
                name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor
            )
        )
        
        //when
        let json = todoItem.json as? Dictionary<String, Any>
        var jsonImportance: TodoItem.Importance?
        
        if let importanceString = json?["importance"] as? String {
            jsonImportance = importanceString ==  "important" ? TodoItem.Importance.important : TodoItem.Importance.unimportant
        } else {
            jsonImportance = TodoItem.Importance.usual
        }
        
        guard let deadline = json?["deadline"] as? String?,
              let dateOfCreation = json?["dateOfCreation"] as? String?,
              let dateOfChange = json?["dateOfChange"] as? String?,
              let jsonId = json?["id"] as? String,
              let jsonText = json?["text"] as? String,
              let jsonIsDone = json?["isDone"] as? Bool
        else {
            XCTFail()
            return
        }
        let jsonDeadline = formatter.date(from: deadline ?? "") ?? nil
        let jsonDateOfCreation = formatter.date(from: dateOfCreation ?? "") ?? nil
        let jsonDateOfChange = formatter.date(from: dateOfChange ?? "") ?? nil
        
        //then
        XCTAssertEqual(jsonId, todoItem.id)
        XCTAssertEqual(jsonText, todoItem.text)
        XCTAssertEqual(jsonImportance, todoItem.importance)
        XCTAssertEqual(
            String(describing: jsonDeadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(
            jsonIsDone,
            todoItem.isDone
        )
        XCTAssertEqual(jsonDateOfCreation, todoItem.dateOfCreation)
        XCTAssertEqual(jsonDateOfChange, todoItem.dateOfChange)
    }
    
    func testCreatingJsonDictionaryWithOptionals() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreationItem = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreationItem,
            dateOfChange: nil,
            category: nil
        )
        
        //when
        let json = todoItem.json as? Dictionary<String, Any>
        var jsonImportance: TodoItem.Importance?
        
        if let importanceString = json?["importance"] as? String {
            jsonImportance = importanceString ==  "important" ? TodoItem.Importance.important : TodoItem.Importance.unimportant
        } else {
            jsonImportance = TodoItem.Importance.usual
        }
        
        guard let deadline = json?["deadline"] as? String?,
              let dateOfCreation = json?["dateOfCreation"] as? String?,
              let dateOfChange = json?["dateOfChange"] as? String?,
              let jsonId = json?["id"] as? String,
              let jsonText = json?["text"] as? String,
              let jsonIsDone = json?["isDone"] as? Bool
                
        else {
            XCTFail()
            return
        }
        let jsonDeadline = formatter.date(from: deadline ?? "") ?? nil
        let jsonDateOfCreation = formatter.date(from: dateOfCreation ?? "") ?? nil
        let jsonDateOfChange = formatter.date(from: dateOfChange ?? "") ?? nil
        
        //then
        XCTAssertEqual(jsonId, todoItem.id)
        XCTAssertEqual(jsonText, todoItem.text)
        XCTAssertEqual(jsonImportance, todoItem.importance)
        XCTAssertEqual(
            String(describing: jsonDeadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(
            jsonIsDone,
            todoItem.isDone
        )
        XCTAssertEqual(jsonDateOfCreation, todoItem.dateOfCreation)
        XCTAssertEqual(jsonDateOfChange, todoItem.dateOfChange)
    }
    
    func testParseJsonDictionary() {
        //given
        let formatter = JsonDateFormatter.standard
        let someDate = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .important,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate,
            category: TodoItem.Category(
                name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor
            )
        )
        
        //when
        let json = TodoItem.parse(json: todoItem.json)
        guard let json else {
            XCTFail()
            return
        }
        
        //then
        XCTAssertEqual(json.id, todoItem.id)
        XCTAssertEqual(json.text, todoItem.text)
        XCTAssertEqual(json.importance, todoItem.importance)
        XCTAssertEqual(
            String(describing: json.deadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(json.isDone, todoItem.isDone)
        XCTAssertEqual(
            String(describing: json.dateOfCreation),
            String(describing:todoItem.dateOfCreation)
        )
        XCTAssertEqual(
            String(describing: json.dateOfChange),
            String(describing: todoItem.dateOfChange)
        )
    }
    
    func testParseJsonDictionaryWithOptionals() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil,
            category: nil
        )
        
        //when
        let json = TodoItem.parse(json: todoItem.json)
        guard let json else {
            XCTFail()
            return
        }
        
        //then
        XCTAssertEqual(json.id, todoItem.id)
        XCTAssertEqual(json.text, todoItem.text)
        XCTAssertEqual(json.importance, todoItem.importance)
        XCTAssertEqual(
            String(describing: json.deadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(json.isDone, todoItem.isDone)
        XCTAssertEqual(
            String(describing: json.dateOfCreation),
            String(describing:todoItem.dateOfCreation)
        )
        XCTAssertEqual(
            String(describing: json.dateOfChange),
            String(describing: todoItem.dateOfChange)
        )
    }
    
    func testConverToCsv() {
        //given
        let formatter = JsonDateFormatter.standard
        let someDate = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .important,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate,
            category: TodoItem.Category(
                name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor
            )
        )
        
        //when
        let csv = todoItem.csv
        
        //then
        XCTAssertTrue(csv.contains(todoItem.id))
        XCTAssertTrue(csv.contains(todoItem.text))
        XCTAssertTrue(csv.contains("\(todoItem.importance)"))
        XCTAssertTrue(csv.contains("\(todoItem.isDone)"))
        XCTAssertTrue(csv.contains(formatter.string(from: todoItem.dateOfCreation)))
    }
    
    func testConverToCsvWithOptionals() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil,
            category: nil
        )
        
        //when
        let csv = todoItem.csv
        
        //then
        XCTAssertTrue(csv.contains(todoItem.id))
        XCTAssertTrue(csv.contains(todoItem.text))
        XCTAssertTrue(!csv.contains("\(todoItem.importance)"))
        XCTAssertTrue(csv.contains("\(todoItem.isDone)"))
        XCTAssertTrue(csv.contains(formatter.string(from: todoItem.dateOfCreation)))
    }
    
    func testParseCsv() {
        //given
        let formatter = JsonDateFormatter.standard
        let someDate = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .unimportant,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate,
            category: TodoItem.Category(
                name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor
            )
        )
        
        //when
        let csv = todoItem.csv
        let todoItemsCsv = TodoItem.parse(csv: csv)
        
        guard let todoItemsCsv else {
            XCTFail()
            return
        }
        
        //then
        XCTAssertEqual(todoItemsCsv.id, todoItem.id)
        XCTAssertEqual(todoItemsCsv.text, todoItem.text)
        XCTAssertEqual(todoItemsCsv.importance, todoItem.importance)
        XCTAssertEqual(
            String(describing: todoItemsCsv.deadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(todoItemsCsv.isDone, todoItem.isDone)
        XCTAssertEqual(
            String(describing: todoItemsCsv.dateOfCreation),
            String(describing:todoItem.dateOfCreation)
        )
        XCTAssertEqual(
            String(describing: todoItemsCsv.dateOfChange),
            String(describing: todoItem.dateOfChange)
        )
    }
    
    func testParseCsvWithOptionals() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil,
            category: nil
        )
        
        //when
        let csv = todoItem.csv
        let todoItemsCsv = TodoItem.parse(csv: csv)
        
        guard let todoItemsCsv else {
            XCTFail()
            return
        }
        
        //then
        XCTAssertEqual(todoItemsCsv.id, todoItem.id)
        XCTAssertEqual(todoItemsCsv.text, todoItem.text)
        XCTAssertEqual(todoItemsCsv.importance, todoItem.importance)
        XCTAssertEqual(
            String(describing: todoItemsCsv.deadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(todoItemsCsv.isDone, todoItem.isDone)
        XCTAssertEqual(
            String(describing: todoItemsCsv.dateOfCreation),
            String(describing:todoItem.dateOfCreation)
        )
        XCTAssertEqual(
            String(describing: todoItemsCsv.dateOfChange),
            String(describing: todoItem.dateOfChange)
        )
    }
}
