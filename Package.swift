// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MijickGridView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "MijickGridView", targets: ["MijickGridView"]),
    ],
    targets: [
        .target(name: "MijickGridView", dependencies: [], path: "Sources"),
        .testTarget(name: "MijickGridViewTests", dependencies: ["MijickGridView"], path: "Tests")
    ]
)
