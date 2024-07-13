//
//  URLSession+Extensions.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 10.07.2024.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let cancellableStorage = CancellableStorage()

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let task = self.dataTask(with: urlRequest) { data, response, _ in

                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                        return
                    }

                    guard let data = data, let response = response else {
                        return
                    }

                    continuation.resume(returning: (data, response))
                }

                task.resume()

                cancellableStorage.add(task as ICancellable)

                if Task.isCancelled {
                    task.cancel()
                    continuation.resume(throwing: CancellationError())
                }
            }
        } onCancel: {
            cancellableStorage.cancel()
        }
    }
}
