import Foundation

/// Production movie service. One instance is created at the composition root
/// and passed to every screen that needs movie data.
final class TMDBMovieService: MovieServicing, Sendable {
    private let configuration: TMDBConfiguration
    private let session: URLSession

    init(configuration: TMDBConfiguration, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func popularMovies() async throws -> [Movie] {
        let response: PopularMoviesResponse = try await get(path: "movie/popular")
        return response.results.map { $0.movie(imageBaseURL: configuration.imageBaseURL) }
    }

    func movie(id: Int) async throws -> Movie {
        let record: MovieRecord = try await get(path: "movie/\(id)")
        return record.movie(imageBaseURL: configuration.imageBaseURL)
    }

    private func get<Response: Decodable>(path: String) async throws -> Response {
        guard configuration.hasAccessToken else {
            throw MovieServiceError.missingAccessToken
        }

        var request = URLRequest(url: try endpoint(path: path))
        request.setValue("Bearer \(configuration.accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieServiceError.invalidResponse
        }
        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            throw MovieServiceError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw MovieServiceError.decodingFailed
        }
    }

    private func endpoint(path: String) throws -> URL {
        guard var components = URLComponents(
            url: configuration.apiBaseURL,
            resolvingAgainstBaseURL: false
        ) else {
            throw MovieServiceError.invalidURL
        }

        let basePath = components.path.hasSuffix("/")
            ? String(components.path.dropLast())
            : components.path
        let relativePath = path.hasPrefix("/") ? path : "/\(path)"
        components.path = basePath + relativePath
        components.queryItems = [URLQueryItem(name: "language", value: "en-US")]

        guard let url = components.url else {
            throw MovieServiceError.invalidURL
        }
        return url
    }
}

private struct PopularMoviesResponse: Decodable {
    let results: [MovieRecord]
}

private struct MovieRecord: Decodable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }

    func movie(imageBaseURL: URL) -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview ?? "",
            posterURL: posterURL(imageBaseURL: imageBaseURL),
            releaseDate: releaseDate ?? ""
        )
    }

    private func posterURL(imageBaseURL: URL) -> URL? {
        guard let posterPath, !posterPath.isEmpty else { return nil }
        let filename = posterPath.hasPrefix("/") ? String(posterPath.dropFirst()) : posterPath
        return imageBaseURL.appending(path: filename)
    }
}
