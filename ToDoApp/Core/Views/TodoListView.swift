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
    @State var showCalendarView = false
    @State var selectedTask: TodoItem?
    
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
        .textCase(nil)
        .padding(.bottom, 12)
    }
    
    var calendarButton: some View {
        Button(action: {
            showCalendarView = true
        }, label: {
            Image(systemName: "calendar")
        })
        .fullScreenCover(isPresented: $showCalendarView, content: {
            CalendarVCRepresentable()
                .edgesIgnoringSafeArea(.all)
                .onDisappear(perform: {
                    viewModel.refreshData()
                })
        })
    }
    
    var todoList: some View {
        List {
            Section {
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
                            viewModel.refreshData()
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
                            TodoItemDetailsView(task: task)
                                .onDisappear(perform: {
                                    viewModel.refreshData()
                                })
                        })
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button() {
                            viewModel.toggleTaskCompletion(task: task)
                            viewModel.refreshData()
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
                    viewModel.refreshData()
                })
        }
        .sheet(item: $selectedTask) {
            task in
            TodoItemDetailsView(task: task)
                .onDisappear(perform: {
                    viewModel.refreshData()
                })
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
            let newTask = viewModel.newTask
            TodoItemDetailsView(task: newTask)
                .onDisappear(perform: {
                    viewModel.refreshData()
                })
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
