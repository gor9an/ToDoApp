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
            id: nil,
            text: "text",
            importance: .important,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate
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
            XCTAssertNotNil(nil)
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
            id: nil,
            text: "text",
            importance: .usual,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreationItem,
            dateOfChange: nil
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
            XCTAssertNotNil(nil)
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
            id: nil,
            text: "text",
            importance: .important,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate
        )
        
        //when
        let json = TodoItem.parse(json: todoItem.json)
        guard let json else {
            XCTAssertNotNil(nil)
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
            id: nil,
            text: "text",
            importance: .usual,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil
        )
        
        //when
        let json = TodoItem.parse(json: todoItem.json)
        guard let json else {
            XCTAssertNotNil(nil)
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
        let todoItems = [
            TodoItem(
                id: nil,
                text: "text",
                importance: .important,
                deadline: someDate,
                isDone: true,
                dateOfCreation: someDate,
                dateOfChange: someDate
            )
        ]
        
        //when
        let csv = TodoItem.converToCsv(todoItems: todoItems)
        print("\(todoItems[0].importance)", todoItems[0].text)
        
        //then
        XCTAssertTrue(csv.contains(todoItems[0].id))
        XCTAssertTrue(csv.contains(todoItems[0].text))
        XCTAssertTrue(csv.contains("\(todoItems[0].importance)"))
        XCTAssertTrue(csv.contains("\(todoItems[0].isDone)"))
        XCTAssertTrue(csv.contains(formatter.string(from: todoItems[0].dateOfCreation)))
    }
    
    func testConverToCsvWithOptionals() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItems = [
            TodoItem(
                id: nil,
                text: "text",
                importance: .usual,
                deadline: nil,
                isDone: true,
                dateOfCreation: dateOfCreation,
                dateOfChange: nil
            )
        ]
        
        //when
        let csv = TodoItem.converToCsv(todoItems: todoItems)
        print("\(todoItems[0].importance)", todoItems[0].text)
        
        //then
        XCTAssertTrue(csv.contains(todoItems[0].id))
        XCTAssertTrue(csv.contains(todoItems[0].text))
        XCTAssertTrue(csv.contains("\(todoItems[0].importance)"))
        XCTAssertTrue(csv.contains("\(todoItems[0].isDone)"))
        XCTAssertTrue(csv.contains(formatter.string(from: todoItems[0].dateOfCreation)))
    }
    
    func testParseCsv() {
        //given
        let formatter = JsonDateFormatter.standard
        let soneDate = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItems = [
            TodoItem(
                id: nil,
                text: "text",
                importance: .unimportant,
                deadline: soneDate,
                isDone: true,
                dateOfCreation: soneDate,
                dateOfChange: soneDate
            ),
            TodoItem(
                id: "123",
                text: "text",
                importance: .important,
                deadline: Date(),
                isDone: true,
                dateOfCreation: soneDate,
                dateOfChange: soneDate
            )
        ]
        
        //when
        let csv = TodoItem.converToCsv(todoItems: todoItems)
        let todoItemsCsv = TodoItem.parse(csv: csv)
        
        guard let todoItemsCsv else {
            XCTAssertNotNil(nil)
            return
        }
        
        //then
        XCTAssertTrue(todoItemsCsv.count == todoItems.count)
        for i in 0..<todoItemsCsv.count {
            XCTAssertEqual(todoItemsCsv[i].id, todoItems[i].id)
            XCTAssertEqual(todoItemsCsv[i].text, todoItems[i].text)
            XCTAssertEqual(todoItemsCsv[i].importance, todoItems[i].importance)
            XCTAssertEqual(
                String(describing: todoItemsCsv[i].deadline),
                String(describing: todoItems[i].deadline)
            )
            XCTAssertEqual(todoItemsCsv[i].isDone, todoItems[i].isDone)
            XCTAssertEqual(
                String(describing: todoItemsCsv[i].dateOfCreation),
                String(describing:todoItems[i].dateOfCreation)
            )
            XCTAssertEqual(
                String(describing: todoItemsCsv[i].dateOfChange),
                String(describing: todoItems[i].dateOfChange)
            )
        }
    }
    
    func testParseCsvWithOptionals() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItems = [
            TodoItem(
                id: nil,
                text: "text",
                importance: .usual,
                deadline: nil,
                isDone: true,
                dateOfCreation: dateOfCreation,
                dateOfChange: nil
            ),
            TodoItem(
                id: "123",
                text: "text",
                importance: .usual,
                deadline: Date(),
                isDone: true,
                dateOfCreation: dateOfCreation,
                dateOfChange: nil
            )
        ]
        
        //when
        let csv = TodoItem.converToCsv(todoItems: todoItems)
        let todoItemsCsv = TodoItem.parse(csv: csv)
        
        guard let todoItemsCsv else {
            XCTAssertNotNil(nil)
            return
        }
        
        //then
        XCTAssertTrue(todoItemsCsv.count == todoItems.count)
        for i in 0..<todoItemsCsv.count {
            XCTAssertEqual(todoItemsCsv[i].id, todoItems[i].id)
            XCTAssertEqual(todoItemsCsv[i].text, todoItems[i].text)
            XCTAssertEqual(todoItemsCsv[i].importance, todoItems[i].importance)
            XCTAssertEqual(
                String(describing: todoItemsCsv[i].deadline),
                String(describing: todoItems[i].deadline)
            )
            XCTAssertEqual(todoItemsCsv[i].isDone, todoItems[i].isDone)
            XCTAssertEqual(
                String(describing: todoItemsCsv[i].dateOfCreation),
                String(describing:todoItems[i].dateOfCreation)
            )
            XCTAssertEqual(
                String(describing: todoItemsCsv[i].dateOfChange),
                String(describing: todoItems[i].dateOfChange)
            )
        }
    }
}
