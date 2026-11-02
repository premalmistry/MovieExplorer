import Foundation
import Observation

@MainActor
@Observable
final class MovieListViewModel {
    private(set) var movies: [Movie] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let movieService: any MovieServicing

    init(movieService: any MovieServicing) {
        self.movieService = movieService
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            movies = try await movieService.popularMovies()
        } catch {
            errorMessage = userFacingMessage(for: error)
        }
    }
}
