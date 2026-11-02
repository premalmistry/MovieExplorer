import XCTest
@testable import MovieExplorer

final class TMDBMovieServiceTests: XCTestCase {
    func testPopularMoviesWithoutATokenThrowsBeforeNetworking() async {
        let service = TMDBMovieService(
            configuration: TMDBConfiguration(
                accessToken: "   ",
                apiBaseURL: TMDBConfiguration.productionAPIBaseURL,
                imageBaseURL: TMDBConfiguration.productionImageBaseURL
            )
        )

        do {
            _ = try await service.popularMovies()
            XCTFail("Expected a missing access token error")
        } catch {
            XCTAssertEqual(error as? MovieServiceError, .missingAccessToken)
        }
    }
}
