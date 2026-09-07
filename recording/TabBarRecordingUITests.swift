import XCTest

@MainActor
final class TabBarRecordingUITests: XCTestCase {
    func testRecordTouchTips() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-onboardingDone", "YES", "-peopleLayout", "default"]
        app.launchEnvironment["TOUCHTIPS_QA_SESSION"] = "C914413B-D56A-4BB2-93C6-6C45E1EAA239"
        app.launchEnvironment["TOUCHTIPS_QA_DATA"] = "showcase"
        app.launch()

        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        if springboard.alerts.buttons["Allow"].waitForExistence(timeout: 3) {
            springboard.alerts.buttons["Allow"].tap()
        }
        XCTAssertTrue(app.buttons["Settings"].waitForExistence(timeout: 15))
        let maya = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "Maya Kapoor")).firstMatch
        XCTAssertTrue(maya.waitForExistence(timeout: 10))
        let search = app.buttons["Search"]
        let expandedWidth = search.frame.width
        let bottom = app.coordinate(withNormalizedOffset: CGVector(dx: 0.55, dy: 0.77))
        let top = app.coordinate(withNormalizedOffset: CGVector(dx: 0.55, dy: 0.30))
        let middle = app.coordinate(withNormalizedOffset: CGVector(dx: 0.55, dy: 0.58))

        print("RECORD_READY")
        Thread.sleep(forTimeInterval: 5)
        bottom.press(forDuration: 0.08, thenDragTo: top, withVelocity: 300, thenHoldForDuration: 0.1)
        Thread.sleep(forTimeInterval: 1.2)
        XCTAssertLessThan(search.frame.width, expandedWidth * 0.95)
        top.press(forDuration: 0.08, thenDragTo: middle, withVelocity: 220, thenHoldForDuration: 0.1)
        Thread.sleep(forTimeInterval: 1.2)
        XCTAssertEqual(search.frame.width, expandedWidth, accuracy: 2)
        bottom.press(forDuration: 0.08, thenDragTo: top, withVelocity: 320, thenHoldForDuration: 0.1)
        Thread.sleep(forTimeInterval: 1.0)
        app.buttons["People"].tap()
        Thread.sleep(forTimeInterval: 1.3)
        XCTAssertEqual(search.frame.width, expandedWidth, accuracy: 2)
        XCTAssertTrue(maya.isHittable)
        maya.tap()
        XCTAssertTrue(app.staticTexts["person-name"].waitForExistence(timeout: 5))
        Thread.sleep(forTimeInterval: 1.5)
        app.buttons["Back"].tap()
        Thread.sleep(forTimeInterval: 1.5)
        XCTAssertTrue(maya.isHittable)
        print("RECORD_FINISHED")
        Thread.sleep(forTimeInterval: 1)
    }
}
