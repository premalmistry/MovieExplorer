import SwiftUI

/// Composition root. This is the one place that decides which movie service exists.
@main
@MainActor
struct MovieExplorerApp: App {
    private let movieService: TMDBMovieService
    private let listViewModel: MovieListViewModel

    init() {
        let configuration = TMDBConfiguration.loadFromEnvironment()
        let movieService = TMDBMovieService(configuration: configuration)
        self.movieService = movieService
        self.listViewModel = MovieListViewModel(movieService: movieService)
    }

    var body: some Scene {
        WindowGroup {
            MovieListView(
                viewModel: listViewModel,
                makeDetailViewModel: { movieID in
                    MovieDetailViewModel(movieID: movieID, movieService: movieService)
                }
            )
        }
    }
}
