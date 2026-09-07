import XCTest

@MainActor
final class TabBarUITests: XCTestCase {
    func testScrollAndNavigation() {
        let app = XCUIApplication()
        app.launch()
        let bar = app.otherElements["minimizing-tab-bar"]
        XCTAssertTrue(bar.waitForExistence(timeout: 10))
        let scroll = app.scrollViews["people-scroll"]
        scroll.swipeUp(velocity: .slow)
        XCTAssertTrue(NSPredicate(format: "value == %@", "Minimized").evaluate(with: bar))
        scroll.swipeDown(velocity: .slow)
        XCTAssertEqual(bar.value as? String, "Expanded")
        scroll.swipeUp(velocity: .slow)
        XCTAssertEqual(bar.value as? String, "Minimized")
        app.buttons["Places"].tap()
        XCTAssertTrue(app.staticTexts["Around here."].exists)
        XCTAssertEqual(bar.value as? String, "Expanded")
        app.scrollViews.firstMatch.swipeUp(velocity: .slow)
        XCTAssertEqual(bar.value as? String, "Expanded")
        app.buttons["People"].tap()
        app.buttons["person-0"].tap()
        XCTAssertTrue(app.buttons["Back"].exists)
        app.buttons["Back"].tap()
        XCTAssertTrue(app.staticTexts["Good company."].exists)
        app.buttons["Search"].tap()
        XCTAssertTrue(app.navigationBars["Find someone"].waitForExistence(timeout: 3))
        app.buttons["Done"].tap()
    }

    /// Deliberately paced real gestures, used by scripts/record.sh.
    func testRecordDemo() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons["People"].waitForExistence(timeout: 10))
        print("RECORD_READY")
        Thread.sleep(forTimeInterval: 5)
        let scroll = app.scrollViews["people-scroll"]
        let start = scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.82))
        let end = scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.28))
        start.press(forDuration: 0.12, thenDragTo: end, withVelocity: 300, thenHoldForDuration: 0.15)
        Thread.sleep(forTimeInterval: 1.4)
        end.press(forDuration: 0.12, thenDragTo: scroll.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.53)), withVelocity: 220, thenHoldForDuration: 0.15)
        Thread.sleep(forTimeInterval: 1.4)
        start.press(forDuration: 0.12, thenDragTo: end, withVelocity: 350, thenHoldForDuration: 0.15)
        Thread.sleep(forTimeInterval: 1.2)
        app.buttons["Places"].tap()
        Thread.sleep(forTimeInterval: 1.6)
        app.buttons["People"].tap()
        Thread.sleep(forTimeInterval: 1)
        app.buttons["person-0"].tap()
        Thread.sleep(forTimeInterval: 1.7)
        app.buttons["Back"].tap()
        Thread.sleep(forTimeInterval: 2)
        print("RECORD_FINISHED")
    }
}
