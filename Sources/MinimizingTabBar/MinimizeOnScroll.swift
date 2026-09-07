import SwiftUI

public extension View {
    /// Attach directly to a vertical ScrollView or List. Deceleration and programmatic
    /// scrolling do not change the bar; only an active drag does.
    func minimizesTabBarOnScroll(_ state: TabBarState) -> some View {
        modifier(MinimizeOnScroll(state: state))
    }
}

private struct MinimizeOnScroll: ViewModifier {
    let state: TabBarState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.contentSize.height > geometry.containerSize.height
            } action: { _, scrollable in
                state.updateContent(scrollable: scrollable, animated: !reduceMotion)
            }
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            } action: { _, offset in
                state.move(to: offset)
            }
            .onScrollPhaseChange { old, new, context in
                let offset = context.geometry.contentOffset.y + context.geometry.contentInsets.top
                if new == .interacting {
                    state.begin(at: offset)
                } else if old == .interacting {
                    state.end(at: offset, animated: !reduceMotion)
                }
            }
    }
}
