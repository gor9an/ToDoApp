//
//  NetworkError.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 19.07.2024.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case unexpectedResponse(URLResponse)
    case badResponse(URLResponse)
    case invalidDecoding(String)
    case invalidEncoding(String)
    case invalidNetworkingItem
}
