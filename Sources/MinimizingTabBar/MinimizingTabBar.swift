import SwiftUI

public struct TabBarItem<Value: Hashable>: Identifiable {
    public let id: Value
    public let title: String
    public let systemImage: String

    public init(_ id: Value, title: String, systemImage: String) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }
}

/// A floating glass capsule with independent leading and trailing actions.
/// Place it in a bottom safeAreaInset so the last row remains reachable.
public struct MinimizingTabBar<Selection: Hashable>: View {
    private let items: [TabBarItem<Selection>]
    @Binding private var selection: Selection
    private let state: TabBarState
    private let minimizedScale: CGFloat
    private let onReselect: ((Selection) -> Void)?
    private let leading: Action?
    private let trailing: Action?
    @Namespace private var pill
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public struct Action {
        public let title: String
        public let systemImage: String
        public let perform: () -> Void

        public init(_ title: String, systemImage: String, perform: @escaping () -> Void) {
            self.title = title
            self.systemImage = systemImage
            self.perform = perform
        }
    }

    public init(
        items: [TabBarItem<Selection>], selection: Binding<Selection>, state: TabBarState,
        minimizedScale: CGFloat = 0.85,
        leading: Action? = nil, trailing: Action? = nil,
        onReselect: ((Selection) -> Void)? = nil
    ) {
        precondition((0.76...1).contains(minimizedScale), "Keep the minimized target at least 44 points high")
        self.items = items
        self._selection = selection
        self.state = state
        self.minimizedScale = minimizedScale
        self.leading = leading
        self.trailing = trailing
        self.onReselect = onReselect
    }

    public var body: some View {
        HStack(spacing: 12) {
            if let leading { actionButton(leading).transition(.opacity.combined(with: .scale)) }
            HStack(spacing: 0) {
                ForEach(items) { item in
                    Button {
                        state.restore(animated: !reduceMotion)
                        if selection == item.id { onReselect?(item.id) }
                        else { selection = item.id }
                    } label: {
                        Image(systemName: item.systemImage)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.primary.opacity(selection == item.id ? 1 : 0.5))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .background {
                        if selection == item.id {
                            Capsule().fill(.primary.opacity(0.12)).padding(5)
                                .matchedGeometryEffect(id: "selection", in: pill)
                        }
                    }
                    .accessibilityLabel(item.title)
                    .accessibilityAddTraits(selection == item.id ? .isSelected : [])
                }
            }
            .modifier(BarGlass(opaque: reduceTransparency))
            if let trailing { actionButton(trailing) }
        }
        .scaleEffect(1 - state.progress * (1 - minimizedScale), anchor: .bottom)
        .simultaneousGesture(DragGesture(minimumDistance: 0).onChanged { _ in
            state.restore(animated: !reduceMotion)
        })
        .animation(reduceMotion ? nil : .snappy, value: selection)
        .animation(reduceMotion ? nil : .snappy, value: leading != nil)
        .onChange(of: selection) { _, _ in state.restore(animated: !reduceMotion) }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("minimizing-tab-bar")
        .accessibilityValue(state.progress > 0.5 ? "Minimized" : "Expanded")
    }

    private func actionButton(_ action: Action) -> some View {
        Button {
            state.restore(animated: !reduceMotion)
            action.perform()
        } label: {
            Image(systemName: action.systemImage)
                .font(.system(size: 22, weight: .medium))
                .frame(width: 58, height: 58)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .modifier(BarGlass(opaque: reduceTransparency))
        .accessibilityLabel(action.title)
    }
}

private struct BarGlass: ViewModifier {
    let opaque: Bool
    func body(content: Content) -> some View {
        if opaque {
            content.background(Color(uiColor: .secondarySystemBackground), in: .capsule)
        } else {
            content.glassEffect(.clear.interactive(), in: .capsule)
        }
    }
}
