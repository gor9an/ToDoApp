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
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
        label.layer.borderColor = UIColor(named: "supportSeparator")?.cgColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 70),
            label.widthAnchor.constraint(equalToConstant: 70),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func selectCell() {
        label.backgroundColor = .backSecondary
        label.layer.borderWidth = 1
    }
    
    func deselectCell() {
        label.backgroundColor = .clear
        label.layer.borderWidth = 0
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
