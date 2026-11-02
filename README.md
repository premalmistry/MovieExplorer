# Movie Explorer

A two-screen SwiftUI sample for [Dependency Injection in Swift — Part 1: Constructor Injection](docs/dependency-injection-in-swift-part-1.md).

The list shows popular movies. The detail screen shows the poster, title, overview, and release date. There is no search, paging, or cache. The project exists to show a composition root.

## Token

The app reads `TMDB_ACCESS_TOKEN` from the process environment. Use the API Read Access Token from your TMDB account. The service sends it as `Authorization: Bearer`. The repository does not contain a token.

In Xcode, edit the Movie Explorer scheme, open Run, then Arguments, then Environment Variables. Enable `TMDB_ACCESS_TOKEN` and paste the token. The shared scheme ships with that variable disabled so an empty value does not override your shell environment.

Without a token the app stays on screen and explains how to set the variable. It does not send a request.

## Tests

The unit tests use `MockMovieService` and do not call TMDB.

```sh
xcodebuild test -project MovieExplorer.xcodeproj -scheme MovieExplorer -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Attribution

Each screen has a Credits section with TMDB's official short logo, the notice "This product uses the TMDB API but is not endorsed or certified by TMDB.", and a link to https://www.themoviedb.org. Their SVG file uses a CSS class for the gradient. The asset catalog copy keeps that path and those gradient stops, and puts the fill on the path so iOS draws it. Do not recolor, rotate, flip, or redraw it. See TMDB's [API FAQ](https://developer.themoviedb.org/docs/faq) and [logos page](https://www.themoviedb.org/about/logos-attribution).
