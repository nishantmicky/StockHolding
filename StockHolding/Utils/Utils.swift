//
//  Utils.swift
//  StockHolding
//
//  Created by Nishant Kumar on 20/11/24.
//

import Foundation
import UIKit

class Utils {
    class func getAttributedString(text: String, fromIndex: Int, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let textRange = NSRange(location: fromIndex, length: (text.count - fromIndex))
        attributedString.addAttribute(.foregroundColor, value: color, range: textRange)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: Constants.kHeadingTextSize), range: textRange)
        return attributedString
    }
    
    class func formatAmount(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "₹"
        numberFormatter.locale = Locale(identifier: "en_IN")
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    class func getTotalPNLPercentage(part: Double, total: Double) -> String {
        if total <= 0 {
            return ""
        }
        let percentage = abs((part / total) * 100)
        let formattedString = String(format: "%.2f", percentage)
        return " (\(formattedString)%)"
    }
}
