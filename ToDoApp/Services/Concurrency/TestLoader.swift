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
            try await Task.sleep(nanoseconds: 10000)
            print(
                try await DefaultNetworkingService.shared.getList() as Any
            )
            return
        }
    }

    func cancelTask() {
        task!.cancel()
        DDLogInfo("Task canceled")
    }
}
