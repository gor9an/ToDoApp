//
//  NetworkingItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 19.07.2024.
//

import CocoaLumberjackSwift
import Foundation
import UIKit

struct NetworkingItem: Decodable, Identifiable {
    let id: String
    let text: String
    let importance: String
    let deadline: Int64?
    let done: Bool
    let createdAt: Int64
    let changedAt: Int64
    let lastUpdatedBy: String
    let files: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case importance
        case deadline
        case done
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
        case files
    }

    static func toTodoItem(_ networkingItem: NetworkingItem) -> TodoItem {
        var deadlineTodo: Date?
        if let checkDeadline = networkingItem.deadline {
            deadlineTodo = Date(timeIntervalSince1970: TimeInterval(checkDeadline))
        }

        return TodoItem(
            id: networkingItem.id,
            text: networkingItem.text,
            importance: TodoItem.Importance(rawValue: networkingItem.importance) ?? .basic,
            deadline: deadlineTodo,
            isDone: networkingItem.done,
            dateOfCreation: Date(timeIntervalSince1970: TimeInterval(networkingItem.createdAt)),
            dateOfChange: Date(timeIntervalSince1970: TimeInterval(networkingItem.changedAt)),
            category: nil
        )
    }

    @MainActor static func toNetworkingItem(_ todoItem: TodoItem) -> NetworkingItem? {
        var deadlineTimeInterval: Int64?
        var changedAtTimeInterval = Int64(Date().timeIntervalSince1970)
        if let checkDeadline = todoItem.deadline?.timeIntervalSince1970 {
            deadlineTimeInterval = Int64(checkDeadline)
        }
        if let checkChangedAt = todoItem.dateOfChange {
            changedAtTimeInterval = Int64(checkChangedAt.timeIntervalSince1970)
        }

        let createdAtTimeInterval = todoItem.dateOfCreation.timeIntervalSince1970
        guard let updatedBy = UIDevice.current.identifierForVendor?.uuidString
        else { return nil }
        return NetworkingItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance.rawValue,
            deadline: deadlineTimeInterval,
            done: todoItem.isDone,
            createdAt: Int64(createdAtTimeInterval),
            changedAt: Int64(changedAtTimeInterval),
            lastUpdatedBy: String(describing: updatedBy),
            files: nil
        )
    }

    var json: Any {
        var networkingItem: [String: Any] = [
            CodingKeys.id.rawValue: id,
            CodingKeys.text.rawValue: text,
            CodingKeys.importance.rawValue: importance,
            CodingKeys.done.rawValue: done,
            CodingKeys.createdAt.rawValue: createdAt,
            CodingKeys.changedAt.rawValue: changedAt,
            CodingKeys.lastUpdatedBy.rawValue: lastUpdatedBy
        ]

        if let deadline = deadline {
            networkingItem[CodingKeys.deadline.rawValue] = deadline
        }

        if let files = files {
            networkingItem[CodingKeys.files.rawValue] = files
        }

        return networkingItem
    }
}
