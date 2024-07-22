//
//  NetworkingConstants.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 16.07.2024.
//

import Foundation

extension DefaultNetworkingService {
    struct NetworkingConstants {
        static let baseURL = URL(string: "https://hive.mrdekk.ru/todo")
        static let bearerToken = "Thingol"
        static let revision = "revision"
    }
}
