import Foundation
@testable import MovieExplorer

struct MockMovieService: MovieServicing {
    var popularResult: Result<[Movie], MovieServiceError> = .success([])
    var movieResult: Result<Movie, MovieServiceError> = .failure(.invalidResponse)

    func popularMovies() async throws -> [Movie] {
        try popularResult.get()
    }

    func movie(id: Int) async throws -> Movie {
        try movieResult.get()
    }
}

enum MovieFixtures {
    static let paperPlanets = Movie(
        id: 42,
        title: "Paper Planets",
        overview: "A cartographer discovers a map that rearranges the city overnight.",
        posterURL: URL(string: "https://example.com/paper.jpg"),
        releaseDate: "2024-04-12"
    )
}
