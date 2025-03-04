//
//  SimilarMovieItemView.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

struct SimilarMovieItemView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "\(Constants.imageURLString)\(movie.posterPath ?? "")")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 200)
            .clipped()
            .cornerRadius(8)
        }
        .frame(width: 150)
    }
}

#Preview {
    SimilarMovieItemView(movie: Movie.movieForPreview())
}
