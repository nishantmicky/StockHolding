//
//  HoldingsViewModelTests.swift
//  StockHoldingTests
//
//  Created by Nishant Kumar on 20/11/24.
//

import XCTest
@testable import StockHolding

let mockStocks = [
    Stock(symbol: "MAHABANK", quantity: 990, ltp: 38.05, avgPrice: 35, close: 40),
    Stock(symbol: "ICICI", quantity: 100, ltp: 118.25, avgPrice: 110, close: 105)
]

final class HoldingsViewModelTests: XCTestCase {

    var viewModel: HoldingsViewModel!
    var mockAPI: MockStocksAPIManager!

    override func setUp() {
        super.setUp()
        mockAPI = MockStocksAPIManager()
        viewModel = HoldingsViewModel(stocksAPI: mockAPI)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }
    
    func testFetchHoldingsSuccess() {
        let expectation = self.expectation(description: "Fetch Holdings Success")
        
        viewModel.didUpdateHoldings = {
            XCTAssertEqual(self.viewModel.holdings.count, 2)
            
            let firstStock = self.viewModel.holdings[0]
            XCTAssertEqual(firstStock.symbol, "MAHABANK")
            XCTAssertEqual(firstStock.quantity, 990)
            XCTAssertEqual(firstStock.ltp, 38)
            XCTAssertEqual(firstStock.avgPrice, 35)
            XCTAssertEqual(firstStock.close, 40)
            
            let secondStock = self.viewModel.holdings[1]
            XCTAssertEqual(secondStock.symbol, "ICICI")
            XCTAssertEqual(secondStock.quantity, 100)
            XCTAssertEqual(secondStock.ltp, 118)
            XCTAssertEqual(secondStock.avgPrice, 120)
            XCTAssertEqual(secondStock.close, 105)
            expectation.fulfill()
        }
        
        viewModel.fetchHoldings()
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testGetCurrentValue() {
        viewModel.fetchHoldings()
        
        let currentValue = viewModel.getCurrentValue()
        // MAHABANK: 990 * 38 = 37620
        // ICICI: 100 * 118 = 11800
        // Total current value = 37620 + 11800 = 49420
        XCTAssertEqual(currentValue, 49420.0)
    }
    
    func testGetTotalInvestment() {
        viewModel.fetchHoldings()

        let totalInvestment = viewModel.getTotalInvestment()
        // MAHABANK: 990 * 35 = 34650
        // ICICI: 100 * 120 = 12000
        // Total investment = 34650 + 12000 = 46650
        XCTAssertEqual(totalInvestment, 46650.0)
    }
    
    func testGetTodayPNL() {
        viewModel.fetchHoldings()
        
        let todayPNL = viewModel.getTodayPNL()
        
        // MAHABANK: (40 - 38) * 990 = 1980
        // ICICI: (105 - 118) * 100 = -1300
        // Total today PNL = 3970
        XCTAssertEqual(todayPNL, 680.0)
    }
    
    func testGetTodayPNLText() {
        viewModel.fetchHoldings()
        
        let todayPNLText = viewModel.getTodayPNLText()
        XCTAssertTrue(todayPNLText.string.contains("₹ 680.00"))
        XCTAssertEqual(todayPNLText.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? UIColor, UIColor.systemGreen)
    }
    
    func testGetTotalPNLText() {
        viewModel.fetchHoldings()
        
        let totalPNLText = viewModel.getTotalPNLText()
        // Total PNL = 49420.0 - 46650.0 = 2770.0
        XCTAssertTrue(totalPNLText.string.contains("₹ 2,770.00 (5.94%)"))
        XCTAssertEqual(totalPNLText.attributes(at: 0, effectiveRange: nil)[.foregroundColor] as? UIColor, UIColor.systemGreen)
    }

}
