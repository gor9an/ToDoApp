//
//  NetworkingConstants.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 16.07.2024.
//

import Foundation

extension DefaultNetworkingService {
    enum NetworkingConstants {
        static let baseURL = URL(string: "https://hive.mrdekk.ru/todo")
        static let bearerToken = ""
        static let revision = "revision"
    }

    enum NetworkingHeaders {
        static let authorization = "Authorization"
        static let xLastKnownRevision = "X-Last-Known-Revision"
    }

    enum NetworkingMethods {
        static let get = "GET"
        static let patch = "PATCH"
        static let post = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
    }
}
