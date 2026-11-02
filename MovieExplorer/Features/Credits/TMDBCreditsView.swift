import SwiftUI

/// Credits section required by TMDB. The logo path and gradient stops are
/// TMDB's official short mark. The fill sits on the path so the asset catalog
/// paints it. The notice and link are theirs as well.
struct TMDBCreditsView: View {
    private static let siteURL = URL(string: "https://www.themoviedb.org")!

    var body: some View {
        VStack(spacing: 8) {
            Text("Credits")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Link(destination: Self.siteURL) {
                Image("TMDBLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("The Movie Database")

            Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.bar)
    }
}
