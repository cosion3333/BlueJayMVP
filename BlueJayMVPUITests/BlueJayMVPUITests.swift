//
//  BlueJayMVPUITests.swift
//  BlueJayMVPUITests
//
//  Created by Cosmin Ionescu on 9/1/25.
//

import XCTest

final class BlueJayMVPUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testRecallAnalyzeNavigatesToInsights() throws {
        let app = XCUIApplication()
        app.launch()
        
        let recallInput = app.textFields["Add what you ate or drank…"]
        XCTAssertTrue(recallInput.waitForExistence(timeout: 5))
        
        recallInput.tap()
        recallInput.typeText("fries\n")
        recallInput.tap()
        recallInput.typeText("soda\n")
        
        let analyzeButton = app.buttons["Analyze & Find Swaps"]
        XCTAssertTrue(analyzeButton.isHittable)
        analyzeButton.tap()
        
        let noButton = app.buttons["No"]
        XCTAssertTrue(noButton.waitForExistence(timeout: 3))
        noButton.tap()
        
        XCTAssertTrue(app.navigationBars["Insights"].waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testInsightsFindSwapsShowsFreeTierUpsell() throws {
        let app = XCUIApplication()
        app.launch()
        
        let recallInput = app.textFields["Add what you ate or drank…"]
        XCTAssertTrue(recallInput.waitForExistence(timeout: 5))
        
        recallInput.tap()
        recallInput.typeText("chips\n")
        recallInput.tap()
        recallInput.typeText("cola\n")
        
        app.buttons["Analyze & Find Swaps"].tap()
        XCTAssertTrue(app.buttons["No"].waitForExistence(timeout: 3))
        app.buttons["No"].tap()
        
        let findSwaps = app.buttons["Find Swaps"]
        XCTAssertTrue(findSwaps.waitForExistence(timeout: 5))
        findSwaps.tap()
        
        XCTAssertTrue(app.navigationBars["Blue Jay Swaps"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Unlock All Blue Jay Swaps"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
