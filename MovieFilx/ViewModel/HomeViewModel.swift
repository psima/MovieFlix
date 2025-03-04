//
//  HomeViewModel.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var currentPage = 1
    @Published var isSearching = false
    var onMoviesUpdated: (() -> Void)? // Needed for UIKit to update the data

    @MainActor
    func fetchPopularMovies() {
        isLoading = true
        Task {
            do {
                let movieResponse = try await getPopularMovies(page: currentPage)
                movies.append(contentsOf: movieResponse.results)
                isLoading = false
                onMoviesUpdated?()
            } catch {
                print("Error fetching movies: \(error)")
                self.error = error
                isLoading = false
            }
        }
    }

    @MainActor
    func searchMovies(query: String) {
        isSearching = true
        currentPage = 1
        movies = []
        onMoviesUpdated?() // Avoid index oob
        isLoading = true
        Task {
            do {
                let movieResponse = try await searchMovie(query: query, page: currentPage)
                movies.append(contentsOf: movieResponse.results)
                isLoading = false
                onMoviesUpdated?()
            } catch {
                print("Error searching movies: \(error)")
                self.error = error
                isLoading = false
            }
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
