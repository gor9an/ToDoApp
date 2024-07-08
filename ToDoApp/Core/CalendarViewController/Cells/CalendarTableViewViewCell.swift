//
//  TodoItemCell.swift
//  ToDoApp
//
//  Created by Andrey Gordienko on 03.07.2024.
//

import UIKit
import Foundation

final class CalendarTableViewViewCell: UITableViewCell {
    let label = UILabel()
    let image = UIImageView()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [label, image])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.backgroundColor = .backSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(stackView)
        
        let contentMargin = contentView.layoutMarginsGuide
        
        let stackViewWidthAnchor = stackView.widthAnchor.constraint(equalTo: contentMargin.widthAnchor)
        stackViewWidthAnchor.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: contentMargin.topAnchor, multiplier: 1.0),
            stackViewWidthAnchor,
            stackView.centerXAnchor.constraint(equalTo: contentMargin.centerXAnchor),
            contentMargin.bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1.0)
        ])
    }
    
    func setLabel(for task: TodoItem) {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(
            string: task.text
        )
        
        if task.isDone {
            label.textColor = .labelTertiary
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        } else {
            label.attributedText = attributeString
            label.textColor = .labelPrimary
        }
        
        label.attributedText = attributeString
    }
    
    func setCategory(for task: TodoItem) {
        guard let category = task.category,
              let color = category.hexColor
        else {
            image.image = UIImage()
            image.tintColor = .clear
            return
        }
        
        image.image = UIImage(systemName: "circle.fill")
        image.tintColor = UIColor(hex: color)
    }
}
