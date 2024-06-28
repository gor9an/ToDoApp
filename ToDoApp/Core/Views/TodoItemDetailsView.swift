//
//  TodoItemDetailsView.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import SwiftUI

struct TodoItemDetailsView: View {
    @State var datePickerShow = false
    @StateObject var viewModel = TodoItemViewModel()
    @Environment(\.dismiss)
    var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer()
                todoTextEditor
                
                VStack(spacing: 0) {
                    importancePicker
                    Divider()
                        .padding(.horizontal)
                    deadlineToggle
                    
                    if datePickerShow {
                        Divider()
                            .padding(.horizontal)
                        deadlineDatePicker
                    }
                }
                .background(Color.backSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                deleteButton
                
            }
        }
        .navigationBarTitle("Дело", displayMode: .inline)
        .navigationBarItems(
            leading: dismissButton,
            trailing: saveButton
        )
        .padding(.horizontal, 16)
        .background(Color.backPrimary)
    }
    
    var saveButton: some View {
        Button(action: {
            viewModel.saveTodoItems()
            dismiss()
        },
               label: {
            Text("Cохранить")
        })
    }
    
    var dismissButton: some View {
        Button(
            action: {
                dismiss()
            },
            label: {
                Text("Отменить")
            }
        )
    }
    
    var todoTextEditor: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.task.text)
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .background(Color.backSecondary)
                .padding(16)
            if viewModel.task.text.isEmpty {
                Text("Что надо сделать?")
                    .padding(24)
                    .foregroundColor(Color.labelTertiary)
                    .allowsHitTesting(false)
            }
        }
        .background(Color.backSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    
    var importancePicker: some View {
        HStack(alignment: .center) {
            Text("Важность")
                .padding()
            Spacer()
            Picker("Важность", selection: Binding(get: {
                viewModel.task.importance
            }, set: {
                viewModel.setImportance(importance: $0)
            })) {
                Image(systemName: "arrow.down").tag(TodoItem.Importance.usual)
                Text("нет").tag(TodoItem.Importance.unimportant)
                Image(systemName: "exclamationmark.2")
                    .symbolRenderingMode(.palette)
                    .foregroundColor(.redCustom)
                    .tag(TodoItem.Importance.important)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 150, height: 36)
            .padding(12)
        }
    }
    
    var deadlineToggle: some View {
        Toggle(isOn: Binding(
            get: { viewModel.isDeadlineEnabled },
            set: { _ in
                viewModel.toggleDeadline()
                datePickerShow = false
            }
        )) {
            VStack (alignment: .leading) {
                Text("Сделать до")
                if viewModel.task.deadline != nil && viewModel.isDeadlineEnabled {
                    
                    Button(action: {
                        datePickerShow.toggle()
                    },
                           label: {
                        Text(                            viewModel.task.deadline?.formatted(
                                date: .abbreviated,
                                time: .omitted
                            ) ?? ""
                        )
                        .font(.system(size: 13, weight: .bold))
                    })
                    .font(.caption)
                    .foregroundStyle(.blueCustom)
                }
            }
            .padding(3.5)
        }
        .padding(12.5)
        
    }
    
    var deadlineDatePicker: some View {
        DatePicker(
            "",
            selection: Binding(
                get: { viewModel.task.deadline ?? Date() },
                set: { viewModel.setDeadline(deadline: $0) }
            ),
            in: Date.now...,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .frame(width: 320)
    }
    
    var deleteButton: some View {
        Button (
            action: {
                viewModel.deleteTodoItems()
            },
            label: {
                Text("Удалить")
                    .font(.system(size: 17))
                    .foregroundStyle(.redCustom)
            }
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.vertical, 17)
        .background(Color.backSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    TodoItemDetailsView()
}
