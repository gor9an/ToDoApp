//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import CocoaLumberjackSwift
import UIKit
import SwiftUI
import TodoItemsFileCache

final class CalendarViewController: UIViewController {
    // MARK: Private properties
    private var todoItems = [TodoItem]()
    private let fileCache = FileCache<TodoItem>()

    private lazy var collectionView = UICollectionView()
    private lazy var tableView = UITableView()
    private lazy var addTaskButton = UIButton()
    private lazy var backButton = UIButton(type: .system)

    let dateCellIdentifier = "DateCell"
    let todoCellIdentifier = "TodoItemCell"
    private var dates = [Date]()
    private(set) var datesString = [String]()
    private(set) var todoitemsDates = [String: [TodoItem]]()
    var selected: TodoItem?

    private var formatter = TodoDateFormatter.calendar

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        fetchTodoItems()

        guard todoItems.count != 0 else { return }
        updateCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        DDLogInfo("\(#fileID); \(#function)\nCalendarViewController Did Appear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        fileCache.saveTodoItems()
        DDLogInfo("\(#fileID); \(#function)\nCalendarViewController Did Disappear")
    }

    // MARK: Public functions
    func updateCollectionView() {
        collectionView.reloadData()
        collectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: true,
            scrollPosition: .left
        )
    }

    func updateTableView() {
        tableView.reloadData()
    }

    func tableViewReloadRows(indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }

    func fetchTodoItems() {
        fileCache.fetchTodoItems()
        todoItems = fileCache.todoItems.map { $0.value }.sorted(by: {
            guard let first = $0.deadline else {
                return false
            }
            guard let second = $1.deadline else {
                return true
            }

            return first < second
        })

        fetchDates()
        groupTodoItemsWithDate()
    }

    func updateTask(selectedTask: TodoItem?, isDone: Bool) {
        guard var newTask = selectedTask else { return }
        newTask.isDone = isDone
        fileCache.addNewTask(newTask)
        fileCache.saveTodoItems()
    }

    func toggleIsDone(indexPath: IndexPath, isDone: Bool) {
        todoitemsDates[datesString[indexPath.section]]?[indexPath.row].isDone = isDone
    }

    func scrollTableView(to index: IndexPath) {
        tableView.scrollToRow(
            at: index,
            at: .top,
            animated: true
        )
    }

    func scrollCollectionView(to index: IndexPath) {
        collectionView.scrollToItem(
            at: index,
            at: .left,
            animated: true
        )
    }
}

// MARK: Private functions
private extension CalendarViewController {
    func configureViews() {
        view.backgroundColor = .backSecondary
        navigationItem.title = "Мои дела"
        configureBackButton()
        configureCollectionView()
        configureTableView()
        configureAddTaskButton()
        setUpConstraints()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    func configureBackButton() {
        backButton.setTitle("Назад", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: dateCellIdentifier)

        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.supportSeparator.cgColor
        collectionView.backgroundColor = .backPrimary
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(CalendarTableViewViewCell.self, forCellReuseIdentifier: todoCellIdentifier)

        tableView.backgroundColor = .backPrimary
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false

        tableView.delegate = self
        tableView.dataSource = self
    }

    func configureAddTaskButton() {
        let config =  UIImage.SymbolConfiguration(font: .systemFont(ofSize: 34))
        addTaskButton = UIButton.systemButton(
            with: UIImage(
                systemName: "plus.circle.fill",
                withConfiguration: config
            ) ?? UIImage(),
            target: self,
            action: #selector(addTaskButtonTap)
        )
        addTaskButton.tintColor = .blueCustom
    }

    func setUpConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(addTaskButton)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -1),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 1),
            collectionView.heightAnchor.constraint(equalToConstant: 90),

            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            addTaskButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            addTaskButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16
            )
        ])

    }

    func fetchDates() {
        dates = Array(Set(todoItems.compactMap { $0.deadline })).sorted()
        datesString = [String]()

        for date in dates {
            let current = formatter.string(from: date)
            if !datesString.contains(current) {
                datesString.append(current)
            }
        }
        if dates.count != todoItems.count {
            datesString.append("Другое")
        }
    }

    func groupTodoItemsWithDate() {
        for date in dates {
            let current = formatter.string(from: date)

            todoitemsDates[current] = todoItems.compactMap {
                if let deadline = $0.deadline {
                    return formatter.string(from: deadline)
                    == formatter.string(from: date) ? $0 : nil
                }
                return nil
            }
        }

        todoitemsDates["Другое"] = todoItems.compactMap {
            $0.deadline == nil ? $0 : nil
        }
    }

    // MARK: Objc functions
    @objc
    func backButtonTap() {
        dismiss(animated: true)
    }

    @objc
    func addTaskButtonTap() {
        performTodoItemDetailsView()
    }
}

// MARK: DetailsView
extension CalendarViewController {
    private func performTodoItemDetailsView() {
        let newTask = TodoItem(text: "", importance: .basic, deadline: nil, dateOfChange: nil, category: nil)
        let todoItemDetailsView = TodoItemDetailsView(task: newTask)
            .onDisappear {
                self.fetchTodoItems()
                self.updateTableView()
                self.updateCollectionView()
            }
        let hostingController = UIHostingController(rootView: todoItemDetailsView)
        hostingController.modalPresentationStyle = .popover
        present(hostingController, animated: true)
    }
}
