//
//  ReviewsView.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

struct ReviewsView: View {
    @EnvironmentObject var viewModel: MovieDetailsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if !viewModel.firstReviews(count: 2).isEmpty {
                Text("Reviews")
                    .applyDetailTitleFont()
            }

            // Change the number to display more reviews
            ForEach(viewModel.firstReviews(count: 2), id: \.author) { review in
                VStack(alignment: .leading, spacing: 10) {
                    Text(review.author)
                        .font(.headline)
                        .foregroundStyle(.yellow)
                    Text(viewModel.markdownString(content: review.content))
                        .font(.subheadline)
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            viewModel.fetchMovieReviews()
        }
    }
}

#Preview {
    ReviewsView()
}
