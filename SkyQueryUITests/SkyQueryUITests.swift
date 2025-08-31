////
////  SkyQueryUITests.swift
////  SkyQueryUITests
////
////  Created by Angélica Rodrigues on 04/06/2025.
////

import XCTest
@testable import SkyQuery

final class SearchViewControllerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    func testSearchScreen_UIElementsExist() {
        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.exists)
        
        let clearButton = app.navigationBars.buttons["Clear"]
        XCTAssertTrue(clearButton.exists)
        XCTAssertFalse(clearButton.isEnabled)
    }

    func testSearchFlights() {
        
        let departureField = app.textFields["departureSearchTextField"]
        let arrivalField = app.textFields["arrivalSearchTextField"]
        
        departureField.tap()
        departureField.typeText("OPO")
        
        let departureCell = app.cells.staticTexts["Porto"]
        XCTAssertTrue(departureCell.exists)
        
        departureCell.tap()
        
        arrivalField.tap()
        arrivalField.typeText("BCN")
        
        let arrivalCell = app.cells.staticTexts["Barcelona"]
        XCTAssertTrue(arrivalCell.exists)
        
        arrivalCell.tap()
        
        let dateField = app.textFields["dateField"]
        dateField.tap()
                
        let datePicker = app.datePickers.element(boundBy: 0)
        XCTAssertTrue(datePicker.exists)
        
        let datePickerMonthButton = datePicker/*@START_MENU_TOKEN@*/.buttons["DatePicker.NextMonth"]/*[[".buttons[\"Month\"]",".buttons[\"Next Month\"]",".buttons[\"DatePicker.NextMonth\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(datePickerMonthButton.exists)
        datePickerMonthButton.tap()
        datePicker.staticTexts["1"].tap()
        
        let doneToolbar = app.toolbars["Toolbar"]
        XCTAssertTrue(doneToolbar.exists)
        
        doneToolbar.buttons["Done"].tap()

        app.buttons["searchButton"].tap()
                
        let resultTable = app.tables["FlightsResultsTableView"]
        XCTAssertTrue(resultTable.waitForExistence(timeout: 8))
    }
}
