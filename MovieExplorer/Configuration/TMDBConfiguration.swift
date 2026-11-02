import Foundation

/// Values TMDBMovieService needs. The access token is supplied by the
/// environment so it never has to live in source control.
struct TMDBConfiguration: Equatable, Sendable {
    let accessToken: String
    let apiBaseURL: URL
    let imageBaseURL: URL

    static let productionAPIBaseURL = URL(string: "https://api.themoviedb.org/3")!
    static let productionImageBaseURL = URL(string: "https://image.tmdb.org/t/p/w342")!

    init(accessToken: String, apiBaseURL: URL, imageBaseURL: URL) {
        self.accessToken = accessToken.trimmingCharacters(in: .whitespacesAndNewlines)
        self.apiBaseURL = apiBaseURL
        self.imageBaseURL = imageBaseURL
    }

    static func loadFromEnvironment(
        environment: [String: String] = ProcessInfo.processInfo.environment
    ) -> TMDBConfiguration {
        TMDBConfiguration(
            accessToken: environment["TMDB_ACCESS_TOKEN"] ?? "",
            apiBaseURL: productionAPIBaseURL,
            imageBaseURL: productionImageBaseURL
        )
    }

    var hasAccessToken: Bool {
        !accessToken.isEmpty
    }
}
