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
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: nil,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil
        )
        
        //when
        let json = todoItem.json as? Dictionary<String, String>
        
        var jsonImportance: TodoItem.Importance?
        
        if let importanceString = json?["importance"] {
            jsonImportance = importanceString ==  "important" ? TodoItem.Importance.important : TodoItem.Importance.unimportant
        } else {
            jsonImportance = TodoItem.Importance.usual
        }
        let jsonDeadline = formatter.date(from: json?["deadline"] ?? "") ?? nil
        let jsonDateOfCreation = formatter.date(from: json?["dateOfCreation"] ?? "") ?? nil
        let jsonDateOfChange = formatter.date(from: json?["dateOfChange"] ?? "") ?? nil
        
        //then
        XCTAssertEqual(json?["id"], todoItem.id)
        XCTAssertEqual(json?["text"], todoItem.text)
        XCTAssertEqual(jsonImportance, todoItem.importance)
        XCTAssertEqual(
            String(describing: jsonDeadline),
            String(describing: todoItem.deadline)
        )
        XCTAssertEqual(
            json?["isDone"],
            String(describing: todoItem.isDone)
        )
        XCTAssertEqual(jsonDateOfCreation, todoItem.dateOfCreation)
        XCTAssertEqual(jsonDateOfChange, todoItem.dateOfChange)
    }
    
    func testParseJsonDictionary() {
        //given
        let formatter = JsonDateFormatter.standard
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: nil,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil
        )
        
        //when
        let json = TodoItem.parse(json: todoItem.json)
        guard let json else {
            XCTAssertFalse(json == nil)
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
}
