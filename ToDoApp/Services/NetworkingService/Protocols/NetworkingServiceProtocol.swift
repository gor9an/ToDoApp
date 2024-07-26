//
//  NetworkingServiceProtocol.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 16.07.2024.
//

import Foundation

protocol NetworkingServiceProtocol {
    func setIsDirty()
    func getList() async throws -> [String: TodoItem]?
    @discardableResult
    func updateList(_ items: [String: TodoItem]) async throws -> [String: TodoItem]?

    func getItem(_ id: String) async throws -> TodoItem?
    @discardableResult
    func addItem(_ item: TodoItem) async throws -> TodoItem?
    @discardableResult
    func updateItem(_ item: TodoItem) async throws -> TodoItem?
    @discardableResult
    func deleteItem(_ id: String) async throws -> TodoItem?
}
