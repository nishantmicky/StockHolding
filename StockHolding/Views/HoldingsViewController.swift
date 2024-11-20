//
//  HoldingsViewController.swift
//  StockHolding
//
//  Created by Nishant Kumar on 17/11/24.
//

import Foundation
import UIKit

class HoldingsViewController: UIViewController {
    private var viewModel: HoldingsViewModel!
    
    private var holdingsTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.kStackViewSpacing
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .systemGray5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var summarySheetButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Constants.kCorenerRadius
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var noHoldingsView: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.text = Constants.kNoHoldingsText
        label.font = UIFont.systemFont(ofSize: Constants.kHeadingTextSize)
        return label
    }()
    
    var summaryCollapsedView = CustomSummaryLabel()
    var currentValueLabel = CustomSummaryLabel()
    var totalInvestmentLabel = CustomSummaryLabel()
    var todayPNLLabel = CustomSummaryLabel()
    
    init(viewModel: HoldingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpViews()
        bindViewModel()
        viewModel.fetchHoldings()
    }
    
    func setUpNavigationBar() {
        self.title = Constants.kNavigationTitle
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: Constants.kHeadingTextSize)
        ]
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.titleTextAttributes = attributes
            navigationController.navigationBar.barTintColor = UIColor.systemGray5
        }
    }
    
    func setUpViews() {
        view.backgroundColor = .white
        holdingsTableView.register(HoldingsTableViewCell.self, forCellReuseIdentifier: Constants.kHoldingTableViewCellIdentifier)
        holdingsTableView.dataSource = self
        holdingsTableView.delegate = self
        holdingsTableView.isHidden = true
        noHoldingsView.isHidden = true
        
        summaryCollapsedView.isUserInteractionEnabled = false
        summarySheetButton.addSubview(summaryCollapsedView)
        summarySheetButton.addTarget(self, action: #selector(toggleBottomSheet), for: .touchUpInside)
        
        view.addSubview(noHoldingsView)
        view.addSubview(holdingsTableView)
        view.addSubview(summarySheetButton)
        view.addSubview(stackView)
        
        stackView.isHidden = true
        stackView.addArrangedSubview(currentValueLabel)
        stackView.addArrangedSubview(totalInvestmentLabel)
        stackView.addArrangedSubview(todayPNLLabel)
        
        setUpConstraints()
        
        // Set Static texts.
        summaryCollapsedView.titleText = Constants.kSummaryCollapsedViewTitle
        currentValueLabel.titleText = Constants.kCurrentValueTitle
        totalInvestmentLabel.titleText = Constants.kTotalInvestmentTitle
        todayPNLLabel.titleText = Constants.kTodayPNLTitle
    }
    
    func bindViewModel() {
        viewModel.didUpdateHoldings = { [weak self] in
            let currentValue: Double = self?.viewModel.getCurrentValue() ?? 0.0
            let totalInvestment: Double = self?.viewModel.getTotalInvestment() ?? 0.0
            let todayPNLText: NSAttributedString = self?.viewModel.getTodayPNLText() ?? NSAttributedString(string: "")
            let totalPNLText: NSAttributedString = self?.viewModel.getTotalPNLText() ?? NSAttributedString(string: "")
            
            DispatchQueue.main.async {
                if (self?.viewModel.holdings.count)! > 0 {
                    self?.holdingsTableView.isHidden = false
                } else {
                    self?.noHoldingsView.isHidden = false
                }
                self?.holdingsTableView.reloadData()
                self?.summaryCollapsedView.valueText = totalPNLText
                self?.currentValueLabel.valueText = NSAttributedString(string: Utils.formatAmount(amount: currentValue))
                self?.totalInvestmentLabel.valueText = NSAttributedString(string: Utils.formatAmount(amount: totalInvestment))
                self?.todayPNLLabel.valueText = todayPNLText
            }
        }
    }
    
    @objc func toggleBottomSheet() {
        if stackView.isHidden {
            stackView.isHidden = false
            summaryCollapsedView.titleText = Constants.kSummaryExpandedViewTitle
        } else {
            stackView.isHidden = true
            summaryCollapsedView.titleText = Constants.kSummaryCollapsedViewTitle
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            noHoldingsView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            noHoldingsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            holdingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            holdingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            holdingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            holdingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.kSummaryCollapsedViewHeight),
            
            summarySheetButton.topAnchor.constraint(equalTo: holdingsTableView.bottomAnchor),
            summarySheetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            summarySheetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            summarySheetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            summaryCollapsedView.topAnchor.constraint(equalTo: summarySheetButton.topAnchor),
            summaryCollapsedView.leadingAnchor.constraint(equalTo: summarySheetButton.leadingAnchor),
            summaryCollapsedView.trailingAnchor.constraint(equalTo: summarySheetButton.trailingAnchor),
            summaryCollapsedView.bottomAnchor.constraint(equalTo: summarySheetButton.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: summarySheetButton.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: Constants.kSummaryExpandedViewHeight),
            
            currentValueLabel.heightAnchor.constraint(equalToConstant: Constants.kSummaryLabelHeight),
            totalInvestmentLabel.heightAnchor.constraint(equalToConstant: Constants.kSummaryLabelHeight),
            todayPNLLabel.heightAnchor.constraint(equalToConstant: Constants.kSummaryLabelHeight)
        ])
    }
}

extension HoldingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kHoldingTableViewCellIdentifier, for: indexPath) as! HoldingsTableViewCell
        let stock = viewModel.holdings[indexPath.row]
        let qty = Constants.kNetQuantityText + "\(stock.quantity)"
        let ltp = Constants.kLTPText + Utils.formatAmount(amount: stock.ltp)
        let totalPNL = Constants.kPNLText + Utils.formatAmount(amount: stock.totalPNL)
        var totalPNLColor = UIColor.systemGreen
        if stock.totalPNL < 0 {
            totalPNLColor = UIColor.systemRed
        }
    
        cell.stockSymbolLabel.text = stock.symbol
        cell.quantityLabel.attributedText = Utils.getAttributedString(text: qty, fromIndex: 9, color: UIColor.black)
        cell.lastTradedPriceLabel.attributedText = Utils.getAttributedString(text: ltp, fromIndex: 4, color: UIColor.black)
        cell.stockPNLLabel.attributedText = Utils.getAttributedString(text: totalPNL, fromIndex: 4, color: totalPNLColor)
        
        return cell
    }
}
