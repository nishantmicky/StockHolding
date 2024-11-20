//
//  CustomSummaryLabel.swift
//  StockHolding
//
//  Created by Nishant Kumar on 19/11/24.
//

import Foundation
import UIKit

class CustomSummaryLabel: UIView {
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Constants.kSummaryTextSize)
        return label
    }()
    private var valueLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Constants.kSummaryTextSize)
        return label
    }()
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    var valueText: NSAttributedString? {
        didSet {
            valueLabel.attributedText = valueText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray5
        addSubview(titleLabel)
        addSubview(valueLabel)

        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.kLabelMargin).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.kLabelMargin).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
