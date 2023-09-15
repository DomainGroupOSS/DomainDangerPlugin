// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainDangerPlugin",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DomainDangerPlugin",
            targets: ["DomainDangerPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.13.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
        .package(url: "https://github.com/f-meloni/danger-swift-coverage", from: "1.2.0")
        // Dev dependencies
    ],
    targets: [
        .target(name: "DangerDependencies", dependencies: ["Danger", "DangerSwiftCoverage"]), // dev
        .target(
            name: "DomainDangerPlugin",
            dependencies: ["Danger", "ShellOut", "DangerSwiftCoverage"]
        )
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-commit": [
                "swift test --generate-linuxmain",
                "swift run swiftformat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": [
            "after": [
                "push",
            ],
        ],
    ])
#endif
