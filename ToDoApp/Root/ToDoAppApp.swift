//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 17.06.2024.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    init() {
        CustomLogger.setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
