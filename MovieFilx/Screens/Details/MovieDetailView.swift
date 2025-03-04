//
//  MovieDetailView.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject private var viewModel: MovieDetailsViewModel
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        self.viewModel = MovieDetailsViewModel(movieId: movie.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Movie Image
                MovieHeaderView(movie: movie, movieDetails: viewModel.movieDetails)
                    .environmentObject(viewModel)

                if let overview = viewModel.movieDetails?.overview {
                    Text("description")
                        .applyDetailTitleFont()
                    Text(overview)
                }
                               
                ReviewsView()
                    .environmentObject(viewModel)
                
                SimilarMoviesView()
                    .environmentObject(viewModel)
            }
            .padding()
        }
        .navigationTitle(viewModel.movieDetails?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMovieDetails()
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie.movieForPreview())
}
