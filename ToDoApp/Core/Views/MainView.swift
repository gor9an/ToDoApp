//
//  MainView.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 27.06.2024.
//

import SwiftUI

struct MainView: View {
    @State
    private var showDetails = false
    var body: some View {
        NavigationStack {
            ScrollView {
                Button("Show modal") {
                    showDetails.toggle()
                }.sheet(isPresented: $showDetails, content: {
                    NavigationStack {
                        TodoItemDetailsView()
                    }
                })
    //            VStack {
    //                HStack {
    //
    //                }
    //
    //                List {
    //
    //                }
    //            }
            }
            .background(Color.backPrimary)
            .navigationTitle("Мои дела")
        }
        
    }
        
}

#Preview {
    MainView()
}
