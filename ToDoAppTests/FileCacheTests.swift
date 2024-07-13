//
//  FileCacheTests.swift
//  ToDoAppTests
//
//  Created by Andrey Gordienko on 20.06.2024.
//

@testable import ToDoApp
import Foundation
import XCTest

final class FileCacheTests: XCTestCase {
    func testAddNewTask() {
        // given
        let cache = FileCache()
        let firstToDoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: Date(),
            dateOfChange: nil,
            category: nil
        )
        let secondToDoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: Date(),
            dateOfChange: nil,
            category: nil
        )

        // when
        cache.addNewTask(firstToDoItem)
        cache.addNewTask(secondToDoItem)

        // then
        XCTAssertTrue(cache.todoItems.count == 2)
    }

    func testDelTask() {
        // given
        let cache = FileCache()
        let toDoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: Date(),
            dateOfChange: nil,
            category: nil
        )

        // when
        cache.addNewTask(toDoItem)
        cache.deleteTask(id: toDoItem.id)

        // then
        XCTAssertTrue(cache.todoItems.count == 0)
    }

    func testFileManager() throws {
        // given
        let cache = FileCache()
        let firstToDoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: Date(),
            dateOfChange: nil,
            category: nil
        )
        let secondToDoItem = TodoItem(
            id: UUID().uuidString,
            text: "text",
            importance: .usual,
            deadline: Date(),
            isDone: true,
            dateOfCreation: Date(),
            dateOfChange: nil,
            category: nil
        )

        // when
        cache.addNewTask(firstToDoItem)
        cache.addNewTask(secondToDoItem)
        cache.saveTodoItems(to: "new.json")

        cache.deleteTask(id: firstToDoItem.id)
        cache.deleteTask(id: secondToDoItem.id)
        XCTAssertTrue(cache.todoItems.count == 0)
        cache.fetchTodoItems(from: "new.json")

        // then
        XCTAssertTrue(cache.todoItems.count == 2)
    }
}
