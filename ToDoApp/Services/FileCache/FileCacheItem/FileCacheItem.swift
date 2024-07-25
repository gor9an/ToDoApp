//
//  FileCacheItem.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.07.2024.
//

import Foundation

protocol FileCacheItem {
    var id: String { get }
    var json: Any { get }
    var csv: String { get }

    static func parse(json: Any) -> Self?
    static func parse(csv: String) -> Self?
}
