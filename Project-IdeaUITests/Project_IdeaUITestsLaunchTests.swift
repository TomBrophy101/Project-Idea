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

        // This is to verify the Main Title
        let navigationTitle = app.staticTexts["Project-Idea"]
        XCTAssertTrue(navigationTitle.exists, "The app failed to show the main navigation title on launch.")

        // This is to verify the email generator button exists.
        XCTAssertTrue(app.buttons["at.badge.plus"].exists, "The email generator icon is missing!")

        // This is to verify the Add New Account
        let sectionHeader = app.staticTexts["Add New Account"]
        XCTAssertTrue(sectionHeader.exists, "The input form was not found on launch.")

        // This is to take the screenshot.
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
