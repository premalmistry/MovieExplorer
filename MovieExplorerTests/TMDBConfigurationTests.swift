import XCTest
@testable import MovieExplorer

final class TMDBConfigurationTests: XCTestCase {
    func testLoadFromEnvironmentReadsTheToken() {
        let configuration = TMDBConfiguration.loadFromEnvironment(
            environment: ["TMDB_ACCESS_TOKEN": "  read-token  "]
        )

        XCTAssertEqual(configuration.accessToken, "read-token")
        XCTAssertTrue(configuration.hasAccessToken)
        XCTAssertEqual(configuration.apiBaseURL, TMDBConfiguration.productionAPIBaseURL)
    }

    func testLoadFromEnvironmentHasNoBuiltInToken() {
        let configuration = TMDBConfiguration.loadFromEnvironment(environment: [:])

        XCTAssertFalse(configuration.hasAccessToken)
    }
}
