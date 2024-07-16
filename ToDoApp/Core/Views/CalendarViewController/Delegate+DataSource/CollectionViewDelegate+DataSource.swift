//
//  CollectionViewDelegate+DataSource.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 08.07.2024.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
}

// MARK: UICollectionViewDataSource
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: dateCellIdentifier,
            for: indexPath
        ) as? CalendarCollectionViewCell else {
            return UICollectionViewCell()
        }
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
        ) as? CalendarCollectionViewCell else { return }
        cell.selectCell()
        let currentIndexPath = IndexPath(row: 0, section: indexPath.row)
        scrollTableView(to: currentIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(
            at: indexPath
        ) as? CalendarCollectionViewCell else { return }
        cell.deselectCell()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
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
