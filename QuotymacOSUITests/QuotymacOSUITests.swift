//
//  QuotymacOSUITests.swift
//  QuotymacOSUITests
//
//  Created by Rudrank Riyam on 16/03/22.
//

import XCTest

class QuotymacOSUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()

    }

    func testNavigation() {
        let window = XCUIApplication().windows

        let predicate = NSPredicate(format: "exists == 1")

        let abrahamQuery = window.tables.buttons["Abraham Lincoln"]
        
        expectation(for: predicate, evaluatedWith: abrahamQuery, handler: nil)

        waitForExpectations(timeout: 10, handler: nil)

        abrahamQuery.click()

        window.scrollViews.tables.element.swipeUp()

        let albertQuery = window.tables.buttons["Albert Einstein"]

        expectation(for: predicate, evaluatedWith: albertQuery, handler: nil)

        waitForExpectations(timeout: 10, handler: nil)

        albertQuery.click()

        window.scrollViews.tables.element.swipeDown()

        let kalamQuery = window.tables.buttons["A. P. J. Abdul Kalam"]

        expectation(for: predicate, evaluatedWith: kalamQuery, handler: nil)

        waitForExpectations(timeout: 10, handler: nil)

        kalamQuery.click()
    }
}
