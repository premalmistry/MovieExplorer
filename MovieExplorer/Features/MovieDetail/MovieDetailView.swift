import SwiftUI

struct MovieDetailView: View {
    @State private var viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading && viewModel.movie == nil {
                    ProgressView("Loading movie")
                        .frame(maxWidth: .infinity, minHeight: 240)
                } else if let errorMessage = viewModel.errorMessage, viewModel.movie == nil {
                    ContentUnavailableView {
                        Label("Couldn't Load Movie", systemImage: "film")
                    } description: {
                        Text(errorMessage)
                    } actions: {
                        Button("Try Again") {
                            Task { await viewModel.load() }
                        }
                    }
                } else if let movie = viewModel.movie {
                    poster(for: movie)

                    Text(movie.title)
                        .font(.title.bold())

                    Text(viewModel.releaseDateText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(movie.overview)
                        .font(.body)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(viewModel.movie?.title ?? "Movie")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            TMDBCreditsView()
        }
        .task {
            await viewModel.load()
        }
    }

    private func poster(for movie: Movie) -> some View {
        AsyncImage(url: movie.posterURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFit()
            default:
                Rectangle()
                    .fill(Color.secondary.opacity(0.15))
                    .aspectRatio(2.0 / 3.0, contentMode: .fit)
            }
        }
        .frame(maxWidth: 240)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity)
        .accessibilityLabel("Poster for \(movie.title)")
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        MovieDetailView(
            viewModel: MovieDetailViewModel(movieID: 1, movieService: PreviewMovieService())
        )
    }
}
#endif
