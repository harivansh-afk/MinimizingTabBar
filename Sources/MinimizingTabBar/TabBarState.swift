import SwiftUI

/// Share one state between the bar and each scrolling screen.
@MainActor @Observable
public final class TabBarState {
    public private(set) var progress: CGFloat = 0
    /// Points of finger movement required to fully minimize or restore the bar.
    public let travel: CGFloat

    private var anchor: CGFloat = 0
    private var lastOffset: CGFloat = 0
    private var direction: Bool?
    private var dragging = false
    private var scrollable = false
    private var suppressUntilNextDrag = false
    private static let deadband: CGFloat = 2

    public init(travel: CGFloat = 100) {
        precondition(travel > 0 && travel.isFinite, "travel must be finite and positive")
        self.travel = travel
    }

    /// Call on tab changes, navigation, or a touch on the bar.
    public func restore(animated: Bool = true) {
        suppressUntilNextDrag = true
        setProgress(0, animated: animated)
        anchor = lastOffset
        direction = nil
    }

    func updateContent(scrollable: Bool, animated: Bool) {
        self.scrollable = scrollable
        if !scrollable { restore(animated: animated) }
    }

    func begin(at offset: CGFloat) {
        dragging = true
        suppressUntilNextDrag = false
        lastOffset = offset
        direction = nil
        anchor = offset - progress * travel
    }

    func move(to offset: CGFloat) {
        guard dragging, scrollable, !suppressUntilNextDrag else { return }
        let delta = offset - lastOffset
        lastOffset = offset
        if abs(delta) >= Self.deadband, direction != (delta > 0) {
            direction = delta > 0
            anchor = offset - progress * travel
        }
        progress = min(1, max(0, (offset - anchor) / travel))
    }

    func end(at offset: CGFloat, animated: Bool) {
        dragging = false
        lastOffset = offset
        guard !suppressUntilNextDrag else { return }
        let minimized = scrollable && offset > travel / 2 && (direction ?? (progress > 0.5))
        setProgress(minimized ? 1 : 0, animated: animated)
        direction = nil
        anchor = offset - progress * travel
    }

    private func setProgress(_ value: CGFloat, animated: Bool) {
        if animated {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) { progress = value }
        } else {
            progress = value
        }
    }
}
