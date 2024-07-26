//
//  CalendarVCRepresentable.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import SwiftUI

struct CalendarVCRepresentable: UIViewControllerRepresentable {
    private let fileCache: FileCache<TodoItem>
    private let networkingService: NetworkingServiceProtocol

    init(_ fileCache: FileCache<TodoItem>, _ networkingService: NetworkingServiceProtocol) {
        self.fileCache = fileCache
        self.networkingService = networkingService
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = CalendarViewController(fileCache, networkingService)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        return navigationViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
