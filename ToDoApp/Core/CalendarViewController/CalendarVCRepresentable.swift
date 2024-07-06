//
//  CalendarVCRepresentable.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import SwiftUI

struct CalendarVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = CalendarViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        return navigationViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
