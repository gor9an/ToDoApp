//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import UIKit
import SwiftUI

final class CalendarViewController: UIViewController {
    //MARK: Private properties
    private var todoItems = [TodoItem]() /*{
        didSet {
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }*/
    private let fileCache = FileCache()
    
    private var collectionView: UICollectionView!
    private var tableView: UITableView!
    private var addTaskButton = UIButton()
    private let backButton = UIButton(type: .system)
    
    private let dateCellIdentifier = "DateCell"
    private let todoCellIdentifier = "TodoItemCell"
    private var dates = [Date]()
    private var datesString = [String]()
    private var todoitemsDates = [String: [TodoItem]]()
    private var selected: TodoItem?
    
    private var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        fetchTodoItems()
        
        collectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: true,
            scrollPosition: .left
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fileCache.saveTodoItems()
    }
    
    //MARK: Private functions
    private func configureViews() {
        view.backgroundColor = .backSecondary
        navigationItem.title = "Мои дела"
        configureBackButton()
        configureCollectionView()
        configureTableView()
        configureAddTaskButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func configureBackButton() {
        backButton.setTitle("Назад", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: dateCellIdentifier)
        
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.supportSeparator.cgColor
        collectionView.backgroundColor = .backPrimary
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -1),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 1),
            collectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    private func updateCollectionView() {
        collectionView.reloadData()
        collectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: true,
            scrollPosition: .left
        )
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: todoCellIdentifier)
        
        tableView.backgroundColor = .backPrimary
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureAddTaskButton() {
        let config =  UIImage.SymbolConfiguration(font: .systemFont(ofSize: 34))
        addTaskButton = UIButton.systemButton(
            with: UIImage(
                systemName: "plus.circle.fill",
                withConfiguration: config
            ) ?? UIImage(),
            target: self,
            action: #selector(addTaskButtonTap)
        )
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.tintColor = .blueCustom
        view.addSubview(addTaskButton)
        
        NSLayoutConstraint.activate([
            addTaskButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            addTaskButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTaskButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16
            )
        ])
    }
    
    private func fetchTodoItems() {
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
    
    private func fetchDates() {
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
    
    private func groupTodoItemsWithDate() {
        for date in dates {
            let current = formatter.string(from: date)
            todoitemsDates[current] = todoItems.compactMap{
                if let deadline = $0.deadline {
                    return formatter.string(from: deadline) == formatter.string(from: date) ? $0 : nil
                }
                return nil
            }
        }
        todoitemsDates["Другое"] = todoItems.compactMap{ $0.deadline == nil ? $0 : nil }
    }
    
    private func updateTask(selectedTask: TodoItem?, isDone: Bool) {
        guard var newTask = selectedTask else { return }
        newTask.isDone = isDone
        fileCache.addNewTask(newTask)
        fileCache.saveTodoItems()
    }
    
    //MARK: Objc functions
    @objc
    private func backButtonTap() {
        dismiss(animated: true)
    }
    
    @objc
    private func addTaskButtonTap() {
        performTodoItemDetailsView()
    }
}

// MARK: DetailsView
extension CalendarViewController {
    private func performTodoItemDetailsView() {
        let newTask = TodoItem(text: "", importance: .usual, deadline: nil, dateOfChange: nil, category: nil)
        let todoItemDetailsView = TodoItemDetailsView(task: newTask)
            .onDisappear {
                self.fetchTodoItems()
                self.tableView.reloadData()
                self.updateCollectionView()
            }
        let hostingController = UIHostingController(rootView: todoItemDetailsView)
        hostingController.modalPresentationStyle = .popover
        present(hostingController, animated: true)
    }
}

//MARK: UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
}

//MARK: UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        datesString.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateCellIdentifier, for: indexPath) as! DateCell
        let date = datesString[indexPath.row]
        
        if cell.isSelected {
            cell.selectCell()
        } else {
            cell.deselectCell()
        }
        cell.configure(with: date)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(
            at: indexPath
        ) as? DateCell else { return }
        cell.selectCell()
        let currentIndexPath = IndexPath(row: 0, section: indexPath.row)
        tableView.scrollToRow(
            at: currentIndexPath,
            at: .top,
            animated: true
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(
            at: indexPath
        ) as? DateCell else { return }
        cell.deselectCell()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 80, height: 80)
    }
}

//MARK: UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        datesString[section]
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathsForVisibleRows?.first  else { return }
        let topSection = indexPath.section
        let index = IndexPath(row: topSection, section: 0)
        collectionView.scrollToItem(
            at: index,
            at: .left,
            animated: true
        )
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let key = datesString[indexPath.section]
        let value = indexPath.row
        
        selected = todoitemsDates[key]?[value]
        todoitemsDates[datesString[indexPath.section]]?[indexPath.row].isDone.toggle()
        
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, boolValue in
            self?.updateTask(selectedTask: self?.selected, isDone: true)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            boolValue(true)
        }
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = UIColor(.greenCustom)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let key = datesString[indexPath.section]
        let value = indexPath.row
        
        selected = todoitemsDates[key]?[value]
        todoitemsDates[datesString[indexPath.section]]?[indexPath.row].isDone.toggle()
        
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, boolValue in
            self?.updateTask(selectedTask: self?.selected, isDone: false)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            boolValue(true)
        }
        action.image = UIImage(systemName: "circle")
        action.backgroundColor = UIColor(.supportSeparator)
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        datesString.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        todoitemsDates[datesString[section]]?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: todoCellIdentifier, for: indexPath) as? TodoItemCell,
              let item = todoitemsDates[datesString[indexPath.section]]?[indexPath.row]
        else { return UITableViewCell() }
        cell.setLabel(for: item)
        cell.setCategory(for: item)
        return cell
    }
}
