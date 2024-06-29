//
//  TodoListView.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 27.06.2024.
//

import SwiftUI

struct TodoListView: View {
    @StateObject var viewModel = TodoListViewModel()
    @State var showDetailsView = false
    @State var selectedTask: TodoItem?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                todoHeaderView
                ZStack{
                    todoList
                    addTaskButton
                }
            }
            .navigationTitle("Мои дела")
            .scrollContentBackground(.hidden)
            .background(Color.backPrimary)
        }
    }
    
    var todoHeaderView: some View {
        HStack {
            Text("Выполнено — \(viewModel.tasks.filter { $0.isDone }.count)")
                .font(.system(size: 15))
                .foregroundColor(.labelTertiary)
            Spacer()
            Button(action: {
                viewModel.toggleShowCompletedTasks()
            }) {
                Text(viewModel.showCompletedTasks ? "Скрыть" : "Показать")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.blueCustom)
            }
        }
        .padding(.horizontal, 32)
    }
    
    var todoList: some View {
        List {
            ForEach(viewModel.filteredTasks) { task in
                HStack(alignment: .center) {
                    completionIconView(for: task)
                    if task.importance == .important {
                        Image(systemName: "exclamationmark.2")
                            .foregroundColor(.redCustom)
                    }
                    taskDetailsView(for: task)
                    Spacer()
                    
                    Button(action: {
                        selectedTask = task
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
                }
                .listRowInsets(EdgeInsets())
                .padding(16)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button() {
                        viewModel.deleteTask(task: task)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                    .tint(.redCustom)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button() {
                        selectedTask = task
                    } label: {
                        Label("Инфо", systemImage: "info.circle")
                    }
                    .sheet(item: $selectedTask, content: { task in
                        NavigationStack {
                            TodoItemDetailsView(viewModel: TodoItemDetailsViewModel(task: task, todoListViewModel: viewModel))
                        }
                    })
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button() {
                        viewModel.toggleTaskCompletion(task: task)
                    } label: {
                        Label("Выполнить", systemImage: "checkmark.circle.fill")
                    }
                    .tint(.greenCustom)
                }
            }
            
            Button(
                action: {
                    showDetailsView.toggle()
                },
                label: {
                    Text("Новое")
                }
            )
            .padding(.horizontal, 35)
            .padding(.vertical, 16)
            .tint(.labelTertiary)
        }
        .sheet(isPresented: $showDetailsView) {
            NavigationStack {
                let newTask = viewModel.newTask
                TodoItemDetailsView(
                    viewModel: TodoItemDetailsViewModel(
                        task: newTask,
                        todoListViewModel: viewModel
                    )
                )
            }
        }
        .sheet(item: $selectedTask) {
            task in
            NavigationStack {
                TodoItemDetailsView(
                    viewModel: TodoItemDetailsViewModel(task: task, todoListViewModel: viewModel)
                )            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var addTaskButton: some View {
        Button(action: {
            showDetailsView.toggle()
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(.blueCustom)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .sheet(isPresented: $showDetailsView) {
            NavigationStack {
                let newTask = viewModel.newTask
                TodoItemDetailsView(
                    viewModel: TodoItemDetailsViewModel(
                        task: newTask,
                        todoListViewModel: viewModel
                    )
                )
            }
        }
        .padding()
    }
    
    func completionIconView(for task: TodoItem) -> some View {
        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
            .resizable()
            .foregroundColor( task.isDone ? .greenCustom : task.importance == .important ? .redCustom : .supportSeparator)
            .frame(width: 24, height: 24)
    }
    
    func taskDetailsView(for task: TodoItem) -> some View {
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
}

#Preview {
    TodoListView()
}
