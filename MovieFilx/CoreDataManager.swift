//
//  CoreDataManager.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 3/3/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "FavoriteMovie")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveMovieAsFavorite(_ movie: Movie) {
         let favoriteMovie = FavoriteMovie(context: context)
         favoriteMovie.id = Int64(movie.id)
         favoriteMovie.adult = movie.adult
         favoriteMovie.title = movie.title
         favoriteMovie.originalTitle = movie.originalTitle
         favoriteMovie.originalLanguage = movie.originalLanguage
         favoriteMovie.overview = movie.overview
         favoriteMovie.backdropPath = movie.backdropPath
         favoriteMovie.posterPath = movie.posterPath
         favoriteMovie.releaseDate = movie.releaseDate
         favoriteMovie.voteAverage = movie.voteAverage
         favoriteMovie.voteCount = Int64(movie.voteCount)
         favoriteMovie.popularity = movie.popularity
         favoriteMovie.video = movie.video

         do {
             try context.save()
         } catch {
             print("Error saving movie as favorite: \(error)")
         }
     }

    func loadFavoriteMovie(withID movieID: Int) -> Movie? {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            if let favoriteMovie = favoriteMovies.first {
                return Movie(
                    id: Int(favoriteMovie.id),
                    adult: favoriteMovie.adult,
                    title: favoriteMovie.title ?? "",
                    originalTitle: favoriteMovie.originalTitle ?? "",
                    originalLanguage: favoriteMovie.originalLanguage ?? "",
                    overview: favoriteMovie.overview ?? "",
                    backdropPath: favoriteMovie.backdropPath,
                    posterPath: favoriteMovie.posterPath,
                    releaseDate: favoriteMovie.releaseDate,
                    voteAverage: favoriteMovie.voteAverage,
                    voteCount: Int(favoriteMovie.voteCount),
                    popularity: favoriteMovie.popularity,
                    genreIDs: [],
                    video: favoriteMovie.video
                )
            }
        } catch {
            print("Error loading favorite movie: \(error)")
        }

        return nil
    }

    func isMovieFavorite(movieID: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if movie is favorite: \(error)")
            return false
        }
    }

    func removeMovieFromFavorites(movieID: Int) {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)

        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            if let favoriteMovie = favoriteMovies.first {
                context.delete(favoriteMovie)
                try context.save()
            }
        } catch {
            print("Error removing movie from favorites: \(error)")
        }
    }
}
