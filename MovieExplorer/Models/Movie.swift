import Foundation

struct Movie: Identifiable, Equatable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let releaseDate: String
}
