// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PersonalHealthTracker",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "PersonalHealthTracker",
            targets: ["PersonalHealthTracker"]),
    ],
    targets: [
        .executableTarget(
            name: "PersonalHealthTracker")
    ]
)
