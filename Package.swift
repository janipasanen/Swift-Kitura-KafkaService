// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KituraKafkaService",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Kitura/Kitura", from: "2.8.0"),
        .package(url: "https://github.com/Kitura/HeliumLogger.git", from: "1.7.1"),
        .package(url: "https://github.com/Kitura/CloudEnvironment.git", from: "9.0.0"),
        .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.0.0"),
        .package(url: "https://github.com/Kitura/Health.git", from: "1.0.0"),
        .package(url: "https://github.com/Kitura-Next/SwiftKafka.git", from: "0.0.2"),
        .package(url: "https://github.com/Kitura/Kitura-CouchDB.git", from: "3.2.0")


        //.package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.8.0")),
        //.package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
        //.package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "9.0.0"),
        //.package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.0.0"),
        //.package(url: "https://github.com/IBM-Swift/Health.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "KituraKafkaService", dependencies: [ .target(name: "Application") ]),
        .target(
            name: "Application",
            dependencies: [
                "Kitura",
                "HeliumLogger",
                "CloudEnvironment",
                "SwiftMetrics",
                "Health",
                "SwiftKafka",
                .product(name: "CouchDB", package: "Kitura-CouchDB")
            ]),
        .testTarget(
            name: "ApplicationTests",
                dependencies: [.target(name: "Application"), "Kitura", "HeliumLogger" ])
    ]
)
