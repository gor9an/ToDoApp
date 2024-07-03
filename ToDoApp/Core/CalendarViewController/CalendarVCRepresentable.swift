//
//  CalendarVCRepresentable.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import SwiftUI

struct CalendarVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = CalendarViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
