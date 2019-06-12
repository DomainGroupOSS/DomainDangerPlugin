import Danger
import Foundation


public struct DomainPlugin {
    
    public static func framework() {
        let danger = Danger()
        
        self.general(danger)
        SwiftLint.lint(inline: true)

        //Coverage.spmCoverage(minimumCoverage: 5)
    }

    public static func app() {

        let danger = Danger()

        self.general(danger)

        let hasAppChanges = !danger.git.modifiedFiles.contains { $0.name.contains("Classes") }
        let hasTestChanges = !danger.git.modifiedFiles.contains { $0.name.contains("DomainTests") }

        if hasAppChanges && !hasTestChanges {
            warn("Tests were not updated")
        }
        SwiftLint.lint(inline: true)

        //Coverage.spmCoverage(minimumCoverage: 5)
    }
}

/// This extension is for internal workings of the plugin. It is marked as internal for unit testing.
internal extension DomainPlugin {

    private static func general(_ danger: DangerDSL) {
        let hasChangelog = danger.git.modifiedFiles.contains("CHANGELOG.md")

        let isTrivial = (danger.github.pullRequest.body ?? "" + danger.github.pullRequest.title).contains("[WIP]")

        if !hasChangelog && !isTrivial {
            warn("Please include a CHANGELOG entry.")
        }

        let bigPRThreshold = 500
        if let additionsCount = danger.github.pullRequest.additions, let deletionsCount = danger.github.pullRequest.deletions, ( deletionsCount + additionsCount > bigPRThreshold) {
            warn("Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.")
        }
    }
}

