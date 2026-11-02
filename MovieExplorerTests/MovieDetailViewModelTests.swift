import XCTest
@testable import MovieExplorer

@MainActor
final class MovieDetailViewModelTests: XCTestCase {
    func testLoadSuccessPublishesTheMovie() async {
        let service = MockMovieService(movieResult: .success(MovieFixtures.paperPlanets))
        let viewModel = MovieDetailViewModel(movieID: MovieFixtures.paperPlanets.id, movieService: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.movie, MovieFixtures.paperPlanets)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadFailurePublishesErrorAndNoMovie() async {
        let service = MockMovieService(movieResult: .failure(.httpStatus(404)))
        let viewModel = MovieDetailViewModel(movieID: 99, movieService: service)

        await viewModel.load()

        XCTAssertNil(viewModel.movie)
        XCTAssertEqual(viewModel.errorMessage, MovieServiceError.httpStatus(404).userMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
