// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GridScrollView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "GridScrollView", targets: ["GridScrollView"]),
    ],
    targets: [
        .target(name: "GridScrollView", dependencies: []),
        .testTarget(name: "GridScrollViewTests", dependencies: ["GridScrollView"])
    ]
)
