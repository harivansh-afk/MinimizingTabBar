// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MinimizingTabBar",
    platforms: [.iOS("26.0")],
    products: [.library(name: "MinimizingTabBar", targets: ["MinimizingTabBar"])],
    targets: [.target(name: "MinimizingTabBar")]
)
