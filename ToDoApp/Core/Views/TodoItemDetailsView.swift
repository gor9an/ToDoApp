//
//  TodoItemDetailsView.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 25.06.2024.
//

import CocoaLumberjackSwift
import SwiftUI

struct TodoItemDetailsView: View {
    @State private var datePickerShow = false
    @State private var categoryPickerShow = false
    @ObservedObject private var viewModel: TodoItemDetailsViewModel

    @Environment(\.dismiss)
    private var dismiss
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    init(task: TodoItem) {
        self.viewModel = TodoItemDetailsViewModel(task: task)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Spacer()
                    todoTextEditor

                    if (horizontalSizeClass == .compact
                        && verticalSizeClass == .regular) || (horizontalSizeClass == verticalSizeClass) {
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

                            Divider()
                                .padding(.horizontal)
                            categoryPickerView
                        }
                        .background(Color.backSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        deleteButton
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationBarTitle("Дело", displayMode: .inline)
            .navigationBarItems(
                leading: dismissButton,
                trailing: saveButton
            )
            .padding(.horizontal, 16)
            .background(Color.backPrimary)
            .onAppear {
                DDLogInfo("\(#fileID); \(#function)\nTodoItemDetailsView Appear")
            }
            .onDisappear {
                DDLogInfo("\(#fileID); \(#function)\nTodoItemDetailsView Disappear")
            }
        }
    }

    private var saveButton: some View {

        Button(action: {
            Task {
                do {
                    try await viewModel.saveTask()
                } catch {
                    DDLogError("\(#fileID); \(#function)\n\(error.localizedDescription).")
                }
                viewModel.saveToFileCache()
            }

            dismiss()
        }, label: {
            Text("Cохранить")
        })
        .disabled(viewModel.task.text == "")
    }

    private var dismissButton: some View {
        Button(
            action: {
                dismiss()
            },
            label: {
                Text("Отменить")
            }
        )
    }

    private var todoTextEditor: some View {
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

    private var importancePicker: some View {
        HStack(alignment: .center) {
            Text("Важность")
                .padding()
            Spacer()
            Picker("Важность", selection: Binding(get: {
                viewModel.task.importance
            }, set: {
                viewModel.setImportance(importance: $0)
            })) {
                Image(systemName: "arrow.down").tag(TodoItem.Importance.basic)
                Text("нет").tag(TodoItem.Importance.low)
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

    private var deadlineToggle: some View {
        Toggle(isOn: Binding(
            get: { viewModel.isDeadlineEnabled },
            set: { _ in
                viewModel.toggleDeadline()
                withAnimation {
                    datePickerShow = false
                }
            }
        )) {
            VStack(alignment: .leading) {
                Text("Сделать до")
                if viewModel.task.deadline != nil && viewModel.isDeadlineEnabled {

                    Button(
                        action: {
                            withAnimation {
                                datePickerShow.toggle()
                            }

                        },
                        label: {
                            Text(viewModel.task.deadline?.formatted(
                                date: .abbreviated,
                                time: .omitted) ?? ""
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

    private var deadlineDatePicker: some View {
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
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
    }

    private var categoryPickerView: some View {
        VStack {
            HStack {
                Text("Выбрать категорию")
                    .foregroundColor(.labelPrimary)
                    .padding(16)
                Spacer()
                Button(action: {
                    withAnimation {
                        categoryPickerShow.toggle()
                    }
                }, label: {
                    HStack {
                        Text(viewModel.task.category?.name ?? "Выберите")
                            .padding(16)
                            .foregroundColor(.blueCustom)
                        if let color = viewModel.task.category?.hexColor {
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color.init(hex: color))
                                .padding(.trailing, 16)
                        }
                    }
                })
            }

            if categoryPickerShow {
                Divider()
                    .padding(.horizontal)
                Picker("", selection: Binding(
                    get: { viewModel.task.category ?? viewModel.todoItemCategories[0] },
                    set: { viewModel.setCategory(category: $0) }
                )) {
                    ForEach(viewModel.todoItemCategories) { category in
                        HStack {
                            Text(category.name)
                                .foregroundColor(.labelPrimary)
                            Spacer()
                            if let color = category.hexColor {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(Color.init(hex: color))
                            }
                        }
                        .tag(category)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
            }
        }
    }

    private var deleteButton: some View {
        Button(action: {
            Task {
                do {
                    try await viewModel.deleteTask()
                } catch {
                    DDLogError("\(#fileID); \(#function)\n\(error.localizedDescription).")
                }
            }

            dismiss()
        }, label: {
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
    TodoItemDetailsView(
        task: TodoItem(
            text: "text",
            importance: .basic,
            deadline: Date(),
            dateOfChange: nil,
            category: nil
        )
    )
}
