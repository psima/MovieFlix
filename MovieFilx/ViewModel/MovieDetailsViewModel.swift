//
//  MovieDetailsViewModel.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var similarMovies: [Movie] = []
    @Published var similarMoviesError: Error?
    @Published var movieReviews: Reviews?
    @Published var movieReviewsError: Error?

    private let movieId: Int

    init(movieId: Int) {
        self.movieId = movieId
    }

    @MainActor
    func fetchMovieDetails() {
        isLoading = true
        Task {
            do {
                movieDetails = try await getMovieDetails(movieId: self.movieId)
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
                // Handle the error
            }
        }
    }

    @MainActor
    func fetchSimilarMovies() {
        isLoading = true
        Task {
            do {
                let movieResponse = try await getSimilarMovies(movieId: movieId, page: 1)
                similarMovies = movieResponse.results
                isLoading = false
            } catch {
                similarMoviesError = error
                isLoading = false
                // Handle the error
            }
        }
    }

    @MainActor
    func fetchMovieReviews() {
        isLoading = true
        Task {
            do {
                movieReviews = try await getMovieReviews(movieId: movieId, page: 1)
                isLoading = false
            } catch {
                movieReviewsError = error
                isLoading = false
            }
        }
    }

    // Get only a specific number of Reviews.
    func firstReviews(count: Int) -> [(author: String, content: String)] {
        guard let reviews = movieReviews?.results else { return [] }
        return reviews.prefix(count).compactMap { review in
            guard let author = review.author, let content = review.content else { return nil }
            return (author, content)
        }
    }

    // Content of the reviews are in Markdown Language. Convert the content to AttributedString
    func markdownString(content: String) -> AttributedString {
        let attributedString = try? AttributedString(markdown: content)
        if let attributedString = attributedString {
            return attributedString
        } else {
            return AttributedString(content)
        }
    }
    
    func toggleFavorite(for movie: Movie) {
        if CoreDataManager.shared.isMovieFavorite(movieID: movie.id) {
            CoreDataManager.shared.removeMovieFromFavorites(movieID: movie.id)
        } else {
            CoreDataManager.shared.saveMovieAsFavorite(movie)
        }
    }
}
