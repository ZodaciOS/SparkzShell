// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SparkzShell",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "SparkzShellApp",
            targets: ["SparkzShellApp"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SparkzBridge",
            dependencies: [],
            path: "Sources/SparkzBridge",
            publicHeadersPath: "Include"
        ),

        .executableTarget(
            name: "SparkzShellApp",
            dependencies: ["SparkzBridge"],
            path: "Sources/SparkzShellApp",
            resources: [
                .copy("Resources")
            ]
        )
    ]
)
