# MinimizingTabBar

The custom tab bar from [TouchTips](https://github.com/harivansh-afk/TouchTips), extracted into a SwiftUI package.

<a href="https://github.com/harivansh-afk/MinimizingTabBar/releases/latest/download/demo-x.mp4"><img src="media/preview.gif" alt="The tab bar shrinking and expanding while scrolling in TouchTips" width="320"></a>

Scroll down to shrink it. Reverse direction or touch the bar to bring it back. It follows your finger and snaps into place when you let go. Short lists stay expanded.

**iOS 26+ · Xcode 26+ · Swift 6 · No dependencies**

## Try it

Open `TabBarDemo.xcodeproj`, choose the **TabBarDemo** scheme and an iPhone simulator, then run.

The video above is TouchTips. The included sample is a smaller app for trying the component on its own.

## Add it to your app

Add this URL as a package dependency in Xcode and select the `MinimizingTabBar` product:

```
https://github.com/harivansh-afk/MinimizingTabBar
```

Share a `TabBarState` between the bar and your scroll view:

```swift
import SwiftUI
import MinimizingTabBar

struct Example: View {
    enum Tab: Hashable { case people, places }

    @State private var selection: Tab = .people
    @State private var bar = TabBarState()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<50) { index in
                    Text("\(selection == .people ? "Person" : "Place") \(index)")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
        }
        .minimizesTabBarOnScroll(bar)
        .safeAreaInset(edge: .bottom) {
            MinimizingTabBar(
                items: [
                    TabBarItem(.people, title: "People", systemImage: "person.2"),
                    TabBarItem(.places, title: "Places", systemImage: "map")
                ],
                selection: $selection,
                state: bar
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}
```

You can add separate back and search buttons with `leading` and `trailing` actions. Use `onReselect` to scroll to the top, or call `bar.restore()` when navigating. The [sample app](Demo/TabBarDemoApp.swift) shows both.

The bar supports Reduce Motion and Reduce Transparency. Attach the scroll modifier directly to a vertical `ScrollView` or `List`.

[Tests](VALIDATION.md) · [Recording instructions](recording/README.md) · [Video downloads](https://github.com/harivansh-afk/MinimizingTabBar/releases/latest) · [Forgejo](https://git.harivan.sh/harivansh-afk/MinimizingTabBar)

[MIT](LICENSE) © Harivansh Rathi
