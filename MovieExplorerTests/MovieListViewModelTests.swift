import XCTest
@testable import MovieExplorer

@MainActor
final class MovieListViewModelTests: XCTestCase {
    func testLoadSuccessPublishesMovies() async {
        let service = MockMovieService(popularResult: .success([MovieFixtures.paperPlanets]))
        let viewModel = MovieListViewModel(movieService: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.movies, [MovieFixtures.paperPlanets])
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testLoadFailurePublishesErrorAndLeavesMoviesEmpty() async {
        let service = MockMovieService(popularResult: .failure(.httpStatus(500)))
        let viewModel = MovieListViewModel(movieService: service)

        await viewModel.load()

        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, MovieServiceError.httpStatus(500).userMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
