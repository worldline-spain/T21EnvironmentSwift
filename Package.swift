// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "T21Environment",
    products: [
        .library(
            name: "T21Environment",
            targets: ["T21Environment"]),
    ],
    dependencies: [
        .package(url: "https://github.com/worldline-spain/T21Notifier-iOS.git", from: "2.1.0"),
        .package(url: "https://github.com/worldline-spain/T21LoggerSwift.git", from: "2.1.0"),
        
    ],
    targets: [
        .target(
            name: "T21Environment",
            dependencies: ["T21Notifier", "T21Logger"],
            path: "./src"),
    ]
)
