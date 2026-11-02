import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {
    private(set) var movie: Movie?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let movieID: Int
    private let movieService: any MovieServicing

    init(movieID: Int, movieService: any MovieServicing) {
        self.movieID = movieID
        self.movieService = movieService
    }

    var releaseDateText: String {
        guard let releaseDate = movie?.releaseDate else { return "" }
        return ReleaseDateFormatting.displayString(from: releaseDate)
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            movie = try await movieService.movie(id: movieID)
        } catch {
            errorMessage = userFacingMessage(for: error)
        }
    }
}

enum ReleaseDateFormatting {
    static func displayString(from rawValue: String) -> String {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "Release date unavailable" }

        let parts = trimmed.split(separator: "-")
        guard parts.count == 3,
              let year = Int(parts[0]),
              let month = Int(parts[1]),
              let day = Int(parts[2])
        else {
            return trimmed
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .current
        guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
            return trimmed
        }

        return date.formatted(
            Date.FormatStyle(date: .abbreviated, time: .omitted).locale(Locale.current)
        )
    }
}
