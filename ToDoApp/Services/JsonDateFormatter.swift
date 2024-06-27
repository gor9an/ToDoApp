//
//  JsonDateFormatter.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 19.06.2024.
//

import Foundation

final class JsonDateFormatter {
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    private init() { }
    
    
}
