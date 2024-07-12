//
//  TableViewDelegate+DataSource.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 08.07.2024.
//

import UIKit

// MARK: UITableViewDelegate
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
        todoitemsDates[datesString[indexPath.section]]?[indexPath.row].isDone = true

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, boolValue in
            self?.updateTask(selectedTask: self?.selected, isDone: true)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            boolValue(true)
        }
        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.backgroundColor = UIColor(.greenCustom)
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let key = datesString[indexPath.section]
        let value = indexPath.row

        selected = todoitemsDates[key]?[value]
        todoitemsDates[datesString[indexPath.section]]?[indexPath.row].isDone = false

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

// MARK: UITableViewDataSource
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: todoCellIdentifier,
            for: indexPath
        ) as? CalendarTableViewViewCell,
              let item = todoitemsDates[datesString[indexPath.section]]?[indexPath.row]
        else { return UITableViewCell() }
        cell.setLabel(for: item)
        cell.setCategory(for: item)
        return cell
    }
}
