//
//  TodoListView.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 27.06.2024.
//

import CocoaLumberjackSwift
import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var showDetailsView = false
    @State private var showCalendarView = false
    @State private var selectedTask: TodoItem?

    var body: some View {
        NavigationView {
            ZStack {
                todoList
                addTaskButton
            }
            .navigationTitle("Мои дела")
            .toolbar {
                calendarButton
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.backPrimary)
        .onAppear {
            refreshData()
            DDLogInfo("\(#fileID); \(#function)\nTodoListView Appear")
        }
        .onDisappear {
            refreshData()
            DDLogInfo("\(#fileID); \(#function)\nTodoListView Disappear")
        }
    }

    private var todoHeaderView: some View {
        HStack {
            Text("Выполнено — \(viewModel.tasks.filter { $0.isDone }.count)")
                .font(.system(size: 15))
                .foregroundColor(.labelTertiary)
            Spacer()
            Button(action: {
                viewModel.toggleShowCompletedTasks()
            }, label: {
                Text(viewModel.showCompletedTasks ? "Скрыть" : "Показать")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.blueCustom)
            })
        }
        .textCase(nil)
        .padding(.bottom, 12)
    }

    private var calendarButton: some View {
        Button(action: {
            showCalendarView = true
        }, label: {
            Image(systemName: "calendar")
        })
        .fullScreenCover(isPresented: $showCalendarView, content: {
            CalendarVCRepresentable()
                .edgesIgnoringSafeArea(.all)
                .onDisappear(perform: {
                    refreshData()
                })
        })
    }

    private var todoList: some View {
        List {
            Section {
                ForEach(viewModel.filteredTasks) { task in
                    todoListCell(with: task)
                }

                Button(
                    action: {
                        showDetailsView.toggle()
                    },
                    label: {
                        Text("Новое")
                    }
                )
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .foregroundStyle(.labelTertiary)
            } header: {
                todoHeaderView
            }
        }
        .sheet(isPresented: $showDetailsView) {
            let newTask = viewModel.newTask
            TodoItemDetailsView(task: newTask)
                .onDisappear(perform: {
                    refreshData()
                })
        }
        .sheet(item: $selectedTask) {task in
            TodoItemDetailsView(task: task)
                .onDisappear(perform: {
                    refreshData()
                })
        }
        .listStyle(InsetGroupedListStyle())
    }

    private func todoListCell(with task: TodoItem) -> some View {
        HStack(alignment: .center) {
            completionIconView(for: task)
            if task.importance == .important { Image(systemName: "exclamationmark.2").foregroundColor(.redCustom)}

            taskDetailsView(for: task)
            Spacer()

            Button(action: {
                selectedTask = task
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            })

        }
        .listRowInsets(EdgeInsets())
        .padding(16)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: {
                Task {
                    do {
                        try await viewModel.performDelete(task: task)
                    } catch {
                        DDLogError("\(#fileID); \(#function)\n\(error.localizedDescription).")
                    }
                    viewModel.deleteTask(task: task)
                }

                refreshData()
            }, label: { Label("Удалить", systemImage: "trash") })
            .tint(.redCustom)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: { selectedTask = task }, label: { Label("Инфо", systemImage: "info.circle") })
            .sheet(item: $selectedTask, content: { task in
                TodoItemDetailsView(task: task)
                    .onDisappear(perform: {
                        refreshData()
                    })
            })
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            leadingSwipeButton(task)
        }
    }

    private var addTaskButton: some View {
        Button(action: {
            showDetailsView.toggle()
        }, label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.blueCustom)
        })
        .frame(maxHeight: .infinity, alignment: .bottom)
        .sheet(isPresented: $showDetailsView) {
            let newTask = viewModel.newTask
            TodoItemDetailsView(task: newTask)
                .onDisappear(perform: {
                    refreshData()
                })
        }
        .padding()
    }

    private func completionIconView(for task: TodoItem) -> some View {
        Image(
            systemName: task.isDone ? "checkmark.circle.fill" : "circle"
        )
        .resizable()
        .foregroundColor(
            task.isDone ? .greenCustom
            : task.importance == .important
            ? .redCustom : .supportSeparator)
        .frame(width: 24, height: 24)
    }

    private func leadingSwipeButton(_ task: TodoItem) -> some View {
        Button(action: {
            viewModel.toggleTaskCompletion(task: task)
            Task {
                do {
                    try await viewModel.saveItem(task)

                    await MainActor.run {
                        refreshData()
                    }
                } catch {
                    DDLogError("\(#fileID); \(#function)\n\(error.localizedDescription).")
                }
            }
        }, label: { Label("Выполнить", systemImage: "checkmark.circle.fill") })
        .tint(.greenCustom)
    }

    private func taskDetailsView(for task: TodoItem) -> some View {
        VStack(alignment: .leading) {
            Text(task.text)
                .strikethrough(task.isDone, color: .labelTertiary)
                .foregroundColor(task.isDone ? .labelTertiary : .labelPrimary)
            if let deadline = task.deadline {
                HStack {
                    Image(systemName: "calendar")
                    Text(deadline.formatted(
                        date: .abbreviated,
                        time: .omitted)
                    )
                    .font(.caption)
                }
                .foregroundColor(.labelTertiary)
            }
        }
    }

    private func refreshData() {
        Task {
            do {
                try await viewModel.refreshData()
            } catch {
                DefaultNetworkingService.shared.setIsDirty()
                DDLogError("\(#fileID); \(#function)\n\(error.localizedDescription).")
            }
            await MainActor.run {
                viewModel.saveToFileCache()
                viewModel.updateTasks()
                viewModel.sortTasksByDeadline()
            }
        }
    }
}

#Preview {
    TodoListView()
}
