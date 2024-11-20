//
//  HoldingsTableViewCell.swift
//  StockHolding
//
//  Created by Nishant Kumar on 16/11/24.
//

import Foundation
import UIKit

class HoldingsTableViewCell: UITableViewCell {
    var stockSymbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: Constants.kHeadingTextSize)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Constants.kSubHeadingTextSize)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var lastTradedPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: Constants.kSubHeadingTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var stockPNLLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: Constants.kSubHeadingTextSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(stockSymbolLabel)
        addSubview(quantityLabel)
        addSubview(lastTradedPriceLabel)
        addSubview(stockPNLLabel)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        stockSymbolLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.kLabelMargin).isActive = true
        stockSymbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.kLabelMargin).isActive = true
        
        quantityLabel.topAnchor.constraint(equalTo: stockSymbolLabel.bottomAnchor, constant: Constants.kLabelMargin).isActive = true
        quantityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.kLabelMargin).isActive = true
        quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.kLabelMargin).isActive = true
        
        lastTradedPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.kLabelMargin).isActive = true
        lastTradedPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.kLabelMargin).isActive = true
        
        stockPNLLabel.topAnchor.constraint(equalTo: lastTradedPriceLabel.bottomAnchor, constant: Constants.kLabelMargin).isActive = true
        stockPNLLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.kLabelMargin).isActive = true
        stockPNLLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.kLabelMargin).isActive = true
    }
}
