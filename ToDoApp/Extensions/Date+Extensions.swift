//
//  Date+Extensions.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 28.06.2024.
//

import Foundation

extension Date {
    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
