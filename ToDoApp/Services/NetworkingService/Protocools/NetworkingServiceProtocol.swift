//
//  NetworkingServiceProtocol.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 16.07.2024.
//

import Foundation

protocol NetworkingServiceProtocol {
    func getList() async throws -> [String: TodoItem]?
    func updateList(_ items: [String: TodoItem]) async throws -> [String: TodoItem]?
    func getItem(_ id: String) async throws -> TodoItem?
    func addItem(_ item: TodoItem) async throws -> TodoItem?
    func updateItem(_ item: TodoItem) async throws -> TodoItem?
    func deleteItem(_ id: String) async throws -> TodoItem?
}
