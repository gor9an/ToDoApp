//
//  ListResponse.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 19.07.2024.
//

import CocoaLumberjackSwift
import Foundation

struct ListResponse: Decodable {
    var list: [NetworkingItem]
    var revision: Int32?

    static func decode(data: Data) async throws -> Self {
        let task = Task {
            return try JSONDecoder().decode(Self.self, from: data)
        }

        do {
            return try await task.value
        } catch {
            DDLogError("\(#file); \(#function)\ninvalid decoding\n\(error.localizedDescription))")
            throw NetworkError.invalidDecoding(error.localizedDescription)
        }
    }
}
