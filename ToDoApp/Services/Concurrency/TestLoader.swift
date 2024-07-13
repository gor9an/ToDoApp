//
//  NetworkService.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 13.07.2024.
//

import SwiftUI
import CocoaLumberjackSwift

final class TestLoader: ObservableObject, @unchecked Sendable {

    var task: Task<Void, Never>?
    let url = URL(string: "https://freetestdata.com/wp-content/uploads/2023/11/160-KB.txt")

    func startTask() {
        DDLogInfo("Task started")
        guard let url else { return }
        task = Task {
            try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)

            do {
                let urlRequest = URLRequest(url: url)

                let (data, _) = try await URLSession.shared.dataTask(for: urlRequest)

                await MainActor.run {
                    DDLogInfo("File downloaded, data:\(data)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func cancelTask() {
        task!.cancel()
        DDLogInfo("Task canceled")
    }
}
