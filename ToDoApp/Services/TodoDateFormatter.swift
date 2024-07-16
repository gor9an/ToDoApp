//
//  JsonDateFormatter.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 19.06.2024.
//

import Foundation

final class TodoDateFormatter {
    static let json: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }()

    static let calendar: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private init() { }

}
