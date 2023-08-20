// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GridView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "GridView", targets: ["GridView"]),
    ],
    targets: [
        .target(name: "GridView", dependencies: []),
        .testTarget(name: "GridViewTests", dependencies: ["GridView"])
    ]
)
