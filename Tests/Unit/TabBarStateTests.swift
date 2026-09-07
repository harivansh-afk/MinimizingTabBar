import XCTest
@testable import MinimizingTabBar

@MainActor
final class TabBarStateTests: XCTestCase {
    func testDragReversalContinuesFromCurrentProgress() {
        let state = TabBarState()
        state.updateContent(scrollable: true, animated: false)
        state.begin(at: 200)
        state.move(to: 210)
        state.move(to: 260)
        XCTAssertEqual(state.progress, 0.5, accuracy: 0.001)
        state.move(to: 250)
        XCTAssertEqual(state.progress, 0.5, accuracy: 0.001)
        state.move(to: 230)
        XCTAssertEqual(state.progress, 0.3, accuracy: 0.001)
        state.end(at: 230, animated: false)
        XCTAssertEqual(state.progress, 0)
    }

    func testReleaseSnapsInDragDirectionAndIgnoresDeceleration() {
        let state = TabBarState()
        state.updateContent(scrollable: true, animated: false)
        state.begin(at: 200)
        state.move(to: 210)
        state.move(to: 240)
        state.end(at: 240, animated: false)
        XCTAssertEqual(state.progress, 1)
        state.move(to: 120)
        XCTAssertEqual(state.progress, 1)
    }

    func testShortContentNeverShrinksEvenDuringDrag() {
        let state = TabBarState()
        state.updateContent(scrollable: false, animated: false)
        state.begin(at: 0)
        state.move(to: 20)
        state.move(to: 200)
        XCTAssertEqual(state.progress, 0)
        state.end(at: 200, animated: false)
        XCTAssertEqual(state.progress, 0)
    }

    func testNearTopAndBounceRestore() {
        let state = TabBarState()
        state.updateContent(scrollable: true, animated: false)
        state.begin(at: 0)
        state.move(to: 10)
        state.move(to: 35)
        state.end(at: 35, animated: false)
        XCTAssertEqual(state.progress, 0)
        state.begin(at: 0)
        state.move(to: -40)
        state.end(at: -40, animated: false)
        XCTAssertEqual(state.progress, 0)
    }

    func testRestoreWhileDraggingPersistsUntilNextDrag() {
        let state = TabBarState()
        state.updateContent(scrollable: true, animated: false)
        state.begin(at: 200)
        state.move(to: 210)
        state.move(to: 310)
        XCTAssertEqual(state.progress, 1)
        state.restore(animated: false)
        state.move(to: 410)
        state.end(at: 410, animated: false)
        XCTAssertEqual(state.progress, 0)
        state.begin(at: 410)
        state.move(to: 420)
        state.move(to: 460)
        XCTAssertGreaterThan(state.progress, 0)
    }

    func testContentBecomingShortRestoresBar() {
        let state = TabBarState()
        state.updateContent(scrollable: true, animated: false)
        state.begin(at: 200)
        state.move(to: 210)
        state.move(to: 400)
        state.end(at: 400, animated: false)
        XCTAssertEqual(state.progress, 1)
        state.updateContent(scrollable: false, animated: false)
        XCTAssertEqual(state.progress, 0)
    }
}
