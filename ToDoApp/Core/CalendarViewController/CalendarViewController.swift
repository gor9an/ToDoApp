//
//  CalendarViewController.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import UIKit
import SwiftUI

final class CalendarViewController: UIViewController {
    var todoItems = [TodoItem]()
    
    //MARK: Private properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var addTaskButton = UIButton()
    private let dateCellIdentifier = "DateCell"
    private let todoCellIdentifier = "DateCell"
    
    private let backButton = UIButton(type: .system)

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    //MARK: Private functions
    private func configureViews() {
        view.backgroundColor = .backPrimary
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: dateCellIdentifier)
        collectionView.layer.borderWidth = 0.5
        collectionView.layer.borderColor = UIColor.supportSeparator.cgColor
        collectionView.backgroundColor = .backPrimary
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -1),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 1),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: todoCellIdentifier)
        tableView.backgroundColor = .backPrimary
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    @objc
    private func backButtonTap() {
        dismiss(animated: true)
    }
    
    @objc
    private func addTaskButtonTap() {
        performTodoItemDetailsView()
    }
}

extension CalendarViewController {
    private func performTodoItemDetailsView() {
        let newTask = TodoItem(text: "", importance: .usual, deadline: nil, dateOfChange: nil)
        let todoItemDetailsView = TodoItemDetailsView(task: newTask)
        let hostingController = UIHostingController(rootView: todoItemDetailsView)
        hostingController.modalPresentationStyle = .popover
        present(hostingController, animated: true)
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let dates = todoItems.compactMap { $0.deadline }.sorted()
        return dates.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}

extension CalendarViewController: UITableViewDelegate {
    
}

extension CalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        12
    }
    
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: todoCellIdentifier, for: indexPath) as? TodoItemCell
        else { return UITableViewCell() }
        
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.masksToBounds = true
        
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
