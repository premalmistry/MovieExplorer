import SwiftUI

struct MovieListView: View {
    @State private var viewModel: MovieListViewModel
    private let makeDetailViewModel: @MainActor (Int) -> MovieDetailViewModel

    init(
        viewModel: MovieListViewModel,
        makeDetailViewModel: @escaping @MainActor (Int) -> MovieDetailViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
        self.makeDetailViewModel = makeDetailViewModel
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Movies")
                .navigationDestination(for: Int.self) { movieID in
                    MovieDetailView(viewModel: makeDetailViewModel(movieID))
                }
                .safeAreaInset(edge: .bottom) {
                    TMDBCreditsView()
                }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            ProgressView("Loading movies")
        } else if let errorMessage = viewModel.errorMessage, viewModel.movies.isEmpty {
            ContentUnavailableView {
                Label("Couldn't Load Movies", systemImage: "wifi.exclamationmark")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Try Again") {
                    Task { await viewModel.load() }
                }
            }
        } else if viewModel.movies.isEmpty {
            ContentUnavailableView {
                Label("No Movies", systemImage: "film")
            } description: {
                Text("Popular movies will appear here.")
            } actions: {
                Button("Try Again") {
                    Task { await viewModel.load() }
                }
            }
        } else {
            List(viewModel.movies) { movie in
                NavigationLink(value: movie.id) {
                    MovieRow(movie: movie)
                }
            }
            .listStyle(.plain)
        }
    }
}

private struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Rectangle().fill(Color.secondary.opacity(0.2))
                }
            }
            .frame(width: 50, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .accessibilityHidden(true)

            Text(movie.title)
                .font(.body)
        }
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
#Preview {
    let movieService = PreviewMovieService()
    MovieListView(
        viewModel: MovieListViewModel(movieService: movieService),
        makeDetailViewModel: { movieID in
            MovieDetailViewModel(movieID: movieID, movieService: movieService)
        }
    )
}
#endif
