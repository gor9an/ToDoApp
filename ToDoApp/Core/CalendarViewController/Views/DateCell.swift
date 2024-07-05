//
//  DateCell.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import UIKit

final class DateCell: UICollectionViewCell {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor(named: "supportSeparator")?.cgColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 70),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func selectCell() {
        contentView.backgroundColor = .backSecondary
        contentView.layer.borderWidth = 1
    }
    
    func deselectCell() {
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 0
    }
    
    func configure(with date: String) {
        let formattedDate = date.split(separator: " ").joined(separator: "\n")
        label.text = formattedDate
        label.textColor = .labelTertiary
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
    }
}
