//
//  SimilarMoviesView.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

struct SimilarMoviesView: View {
    @EnvironmentObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.similarMovies.isEmpty {
                Text("Similar Movies")
                    .applyDetailTitleFont()
            }

            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.similarMovies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            SimilarMovieItemView(movie: movie)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchSimilarMovies()
        }
    }
}

#Preview {
    SimilarMoviesView()
}
