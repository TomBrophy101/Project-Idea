//
//  Project_IdeaUITestsLaunchTests.swift
//  Project-IdeaUITests
//
//  Created by Tom Brophy on 10/03/2026.
//

import XCTest

final class Project_IdeaUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunchAndVerifyUI() throws {
        let app = XCUIApplication()
        app.launch()

        // This is to verify the Add New Account
        let mainList = app.collectionViews["MainList"]
        if !mainList.waitForExistence(timeout: 5) {
            let backButton = app.navigationBars.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
            }
        }

        // This is to verify the Main Title
        let titleFound = app.staticTexts["Project-Idea"].waitForExistence(timeout: 5) || app.navigationBars["Project-Idea"].exists

        XCTAssertTrue(titleFound, "The Project Idea title is missing.")

        //This is to verify the section header
        let sectionHeader = app.staticTexts["Add New Account"]
        XCTAssertTrue(sectionHeader.exists, "The section header is missing.")

        // This is to verify the email generator button exists.
        let emailIcon = app.buttons["at.badge.plus_menu"]
        XCTAssertTrue(emailIcon.waitForExistence(timeout: 5), "The email generator button is missing.")

        // This is to take the screenshot.
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
