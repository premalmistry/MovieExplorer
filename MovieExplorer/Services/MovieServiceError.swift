import Foundation

enum MovieServiceError: Error, Equatable, Sendable {
    case missingAccessToken
    case invalidURL
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed

    var userMessage: String {
        switch self {
        case .missingAccessToken:
            "Add your TMDB read access token in the TMDB_ACCESS_TOKEN environment variable."
        case .invalidURL, .invalidResponse, .decodingFailed:
            "The movie service returned an unexpected response."
        case .httpStatus:
            "The movie service is unavailable right now."
        }
    }
}

/// Cancellation is not a failure the screen should display.
func userFacingMessage(for error: Error) -> String? {
    if error is CancellationError {
        return nil
    }
    if let urlError = error as? URLError, urlError.code == .cancelled {
        return nil
    }
    if let serviceError = error as? MovieServiceError {
        return serviceError.userMessage
    }
    return "Something went wrong. Please try again."
}
