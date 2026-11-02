#if DEBUG
import Foundation

/// Stand-in used by SwiftUI previews. It proves the screens can run without TMDB.
struct PreviewMovieService: MovieServicing {
    func popularMovies() async throws -> [Movie] {
        [
            Movie(
                id: 1,
                title: "Paper Planets",
                overview: "A cartographer discovers a map that rearranges the city overnight.",
                posterURL: nil,
                releaseDate: "2024-04-12"
            ),
            Movie(
                id: 2,
                title: "The Last Projector",
                overview: "A projectionist keeps a shuttered cinema open for one more summer.",
                posterURL: nil,
                releaseDate: "1998-08-21"
            ),
        ]
    }

    func movie(id: Int) async throws -> Movie {
        let movies = try await popularMovies()
        guard let movie = movies.first(where: { $0.id == id }) else {
            throw MovieServiceError.invalidResponse
        }
        return movie
    }
}
#endif
