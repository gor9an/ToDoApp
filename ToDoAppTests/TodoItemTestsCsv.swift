//
//  TodoItemTestsCsv.swift
//  ToDoAppTests
//
//  Created by Andrey Gordienko on 11.07.2024.
//

@testable import ToDoApp
import Foundation
import XCTest

final class TodoItemTestsCsv: XCTestCase {
    func testConverToCsv() {
        // given
        let formatter = TodoDateFormatter.json
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

        // when
        let csv = todoItem.csv

        // then
        XCTAssertTrue(csv.contains(todoItem.id))
        XCTAssertTrue(csv.contains(todoItem.text))
        XCTAssertTrue(csv.contains("\(todoItem.importance)"))
        XCTAssertTrue(csv.contains("\(todoItem.isDone)"))
        XCTAssertTrue(csv.contains(formatter.string(from: todoItem.dateOfCreation)))
    }

    func testConverToCsvWithOptionals() {
        // given
        let formatter = TodoDateFormatter.json
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .basic,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil,
            category: nil
        )

        // when
        let csv = todoItem.csv

        // then
        XCTAssertTrue(csv.contains(todoItem.id))
        XCTAssertTrue(csv.contains(todoItem.text))
        XCTAssertTrue(!csv.contains("\(todoItem.importance)"))
        XCTAssertTrue(csv.contains("\(todoItem.isDone)"))
        XCTAssertTrue(csv.contains(formatter.string(from: todoItem.dateOfCreation)))
    }

    func testParseCsv() {
        // given
        let formatter = TodoDateFormatter.json
        let someDate = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .low,
            deadline: someDate,
            isDone: true,
            dateOfCreation: someDate,
            dateOfChange: someDate,
            category: TodoItem.Category(
                name: TodoItemCategory.workName, hexColor: TodoItemCategory.workHexColor
            )
        )

        // when
        let csv = todoItem.csv
        let todoItemsCsv = TodoItem.parse(csv: csv)

        guard let todoItemsCsv else {
            XCTFail("testParseCsv fail")
            return
        }

        // then
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
            String(describing: todoItem.dateOfCreation)
        )
        XCTAssertEqual(
            String(describing: todoItemsCsv.dateOfChange),
            String(describing: todoItem.dateOfChange)
        )
    }

    func testParseCsvWithOptionals() {
        // given
        let formatter = TodoDateFormatter.json
        let dateOfCreation = formatter.date(from: "15-07-2003 00:00:00") ?? Date()
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .basic,
            deadline: nil,
            isDone: true,
            dateOfCreation: dateOfCreation,
            dateOfChange: nil,
            category: nil
        )

        // when
        let csv = todoItem.csv
        let todoItemsCsv = TodoItem.parse(csv: csv)

        guard let todoItemsCsv else {
            XCTFail("testParseCsvWithOptionals fail")
            return
        }

        // then
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
            String(describing: todoItem.dateOfCreation)
        )
        XCTAssertEqual(
            String(describing: todoItemsCsv.dateOfChange),
            String(describing: todoItem.dateOfChange)
        )
    }

}
