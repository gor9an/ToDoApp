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
    private var todoItems = [TodoItem]()
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
        fetchDates()
        groupTodoitemsWithDate()
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
        todoItems = fileCache.todoItems.map { $0.value }
        
        tableView.reloadData()
    }
    
    private func fetchDates() {
        dates = Array(Set(todoItems.compactMap { $0.deadline })).sorted()
        
        for date in dates {
            let current = formatter.string(from: date)
            if !datesString.contains(current) {
                datesString.append(current)
            }
        }
        datesString.append("Другое")
    }
    
    private func groupTodoitemsWithDate() {
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
        let newTask = TodoItem(text: "", importance: .usual, deadline: nil, dateOfChange: nil)
        let todoItemDetailsView = TodoItemDetailsView(task: newTask)
            .onDisappear {
                self.fetchTodoItems()
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
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
              let text = todoitemsDates[
                datesString[indexPath.section]]?[indexPath.row
                ].text
        else { return UITableViewCell() }
        
        cell.textLabel?.text = text
        return cell
    }
}
