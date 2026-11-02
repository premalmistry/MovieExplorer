import Foundation

/// The movie screens depend on this contract, not on TMDB specifically.
/// Constructor injection does not require a protocol; this one exists so tests
/// and previews can supply a different implementation.
protocol MovieServicing: Sendable {
    func popularMovies() async throws -> [Movie]
    func movie(id: Int) async throws -> Movie
}
