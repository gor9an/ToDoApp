//
//  DefaultNetworkingService.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 16.07.2024.
//

import CocoaLumberjackSwift
import Foundation

final class DefaultNetworkingService: NetworkingServiceProtocol {
    static let shared = DefaultNetworkingService(); private init() { }
    private let urlSession = URLSession.shared
    private let httpStatusCodeSuccess = 200..<300
    private var revision: Int32 = 0

    private func performRequest(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await urlSession.dataTask(for: request)
        guard let response = response as? HTTPURLResponse else {
            DDLogError("\(#file); \(#function)\nunexpected response\n\(response))")
            throw NetworkError.unexpectedResponse(response)
        }
        guard httpStatusCodeSuccess.contains(response.statusCode) else {
            DDLogError("\(#file); \(#function)\nbad response\n\(response))")
            throw NetworkError.badResponse(response)
        }

        return (data, response)
    }

    private func sendItem(_ item: TodoItem, _ request: inout URLRequest) async throws -> TodoItem {
        guard let networkingItemsBody = await NetworkingItem.toNetworkingItem(item)?.json else {
            DDLogError("\(#file); \(#function)\ninvalid NetworkingItem")
            throw NetworkError.invalidNetworkingItem
        }

        let element = ["status": "ok", "element": networkingItemsBody]
        let json = try JSONSerialization.data(
            withJSONObject: element
        )

        let requestBody = json

        request.httpBody = requestBody

        let (data, _) = try await performRequest(request: request)
        let response = try await ElementResponse.decode(data: data)

        let networkingItem = response.element
        let todoItem = NetworkingItem.toTodoItem(networkingItem)

        return todoItem
    }

    func getList() async throws -> [String: TodoItem]? {
        guard let url = NetworkingConstants.baseURL?.appending(path: "/list") else {
            DDLogError("\(#file); \(#function)\nbad URl")
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(NetworkingConstants.bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await performRequest(request: request)
        let response = try await ListResponse.decode(data: data)
        let networkingItems = response.list
        if let checkRevision = response.revision {
            revision = checkRevision
        }

        var todoItems = [String: TodoItem]()
        for item in networkingItems {
            todoItems[item.id] = NetworkingItem.toTodoItem(item)
        }

        return todoItems
    }

    func updateList(_ items: [String: TodoItem]) async throws -> [String: TodoItem]? {
        guard let url = NetworkingConstants.baseURL?.appending(path: "/list") else {
            DDLogError("\(#file); \(#function)\nbad URl")
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue( "Bearer \(NetworkingConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(String(describing: revision), forHTTPHeaderField: "X-Last-Known-Revision")

        var networkingItemsBody = [NetworkingItem]()
        for item in items {
            if let checkNil = await NetworkingItem.toNetworkingItem(item.value) {
                networkingItemsBody.append(checkNil)
            }
        }

        let networkingItemsJsons = networkingItemsBody.compactMap { $0.json }
        let list = ["list": networkingItemsJsons]
        let json = try JSONSerialization.data(withJSONObject: list)
        let requestBody = json
        request.httpBody = requestBody

        let (data, _) = try await performRequest(request: request)
        let response = try await ListResponse.decode(data: data)
        let networkingItems = response.list

        if let checkRevision = response.revision {
            revision = checkRevision
        }

        var todoItems = [String: TodoItem]()
        for item in networkingItems {
            todoItems[item.id] = NetworkingItem.toTodoItem(item)
        }

        return todoItems
    }

    func getItem(_ id: String) async throws -> TodoItem? {
        guard let url = NetworkingConstants.baseURL?.appending(path: "/list/\(id)") else {
            DDLogError("\(#file); \(#function)\nbad URl")
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(NetworkingConstants.bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await performRequest(request: request)
        let response = try await ElementResponse.decode(data: data)

        let networkingItem = response.element

        if let checkRevision = response.revision {
            revision = checkRevision
        }
        let todoItems = NetworkingItem.toTodoItem(networkingItem)

        return todoItems
    }

    func addItem(_ item: TodoItem) async throws -> TodoItem? {
        guard let url = NetworkingConstants.baseURL?.appending(path: "/list") else {
            DDLogError("\(#file); \(#function)\nbad URl")
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue( "Bearer \(NetworkingConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(String(describing: revision), forHTTPHeaderField: "X-Last-Known-Revision")

        return try await sendItem(item, &request)
    }

    func updateItem(_ item: TodoItem) async throws -> TodoItem? {
        guard let url = NetworkingConstants.baseURL?.appending(path: "/list/\(item.id)") else {
            DDLogError("\(#file); \(#function)\nbad URl")
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue( "Bearer \(NetworkingConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(String(describing: revision), forHTTPHeaderField: "X-Last-Known-Revision")

        return try await sendItem(item, &request)
    }

    func deleteItem(_ id: String) async throws -> TodoItem? {
        guard let url = NetworkingConstants.baseURL?.appending(path: "/list/\(id)") else {
            DDLogError("\(#file); \(#function)\nbad URl")
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue( "Bearer \(NetworkingConstants.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(String(describing: revision), forHTTPHeaderField: "X-Last-Known-Revision")

        let (data, _) = try await performRequest(request: request)
        let response = try await ElementResponse.decode(data: data)

        let networkingItem = response.element

        if let checkRevision = response.revision {
            revision = checkRevision
        }
        let todoItems = NetworkingItem.toTodoItem(networkingItem)

        return todoItems
    }

}
