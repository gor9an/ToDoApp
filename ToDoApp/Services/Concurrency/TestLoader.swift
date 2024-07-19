//
//  NetworkService.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 13.07.2024.
//

import SwiftUI
import CocoaLumberjackSwift

final class TestLoader: ObservableObject {

    var task: Task<Sendable, Error>?
    let url = URL(string: "https://freetestdata.com/wp-content/uploads/2023/11/160-KB.txt")

    func startTask() {
        DDLogInfo("Task started")
        task = Task {
            print(try await DefaultNetworkingService.shared.getItem("f56e9af7-623e-4171-ab02-df6c9c6d1049") as Any)
//            guard var items = try await DefaultNetworkingService.shared.getList() else { return }
//            items["ab999d87-4655-46d9-9dd3-d96e8e0fee4e"] = TodoItem(
//                id: "ab999d87-4655-46d9-9dd3-d96e8e0fee4e",
//                text: "ddd",
//                importance: .important,
//                deadline: nil,
//                isDone: true,
//                dateOfCreation: Date(),
//                dateOfChange: Date(),
//                category: nil
//            )
//
//            print(
//                try await DefaultNetworkingService.shared.updateList(items) as Any
//            )
//            return

//            print(try await DefaultNetworkingService.shared.addItem(
//                TodoItem(
//                    id: "ab999d87-4655-46d9-9dd3-d96e8e0fee4e",
//                    text: "ddd",
//                    importance: .important,
//                    deadline: nil,
//                    isDone: true,
//                    dateOfCreation: Date(),
//                    dateOfChange: Date(),
//                    category: nil
//                )) as Any)
            print(try await DefaultNetworkingService.shared.updateItem(
                TodoItem(
                    id: "ab999d87-4655-46d9-9dd3-d96e8e0fee4e",
                    text: "dsd",
                    importance: .important,
                    deadline: nil,
                    isDone: true,
                    dateOfCreation: Date(),
                    dateOfChange: Date(),
                    category: nil
                )) as Any)
            return
        }
    }

    func cancelTask() {
        task!.cancel()
        DDLogInfo("Task canceled")
    }
}
