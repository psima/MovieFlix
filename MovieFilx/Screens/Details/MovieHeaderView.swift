//
//  MovieHeaderView.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI
import SkeletonView

struct MovieHeaderView: View {
    var movie: Movie
    var movieDetails: MovieDetails?
    @State var isFavorite: Bool = false
    @EnvironmentObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                AsyncImage(url: URL(string: "\(Constants.imageURLString)\(movieDetails?.backdropPath ?? "")")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    SkeletonViewRepresentable()
                        .frame(height: 200)
                }
                .frame(height: 200)
                .clipped()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            //share
                            if let homepage = movieDetails?.homepage, let url = URL(string: homepage) {
                                // This is only to share for previous iOS versions. ShareLink is available for iOS16.
                                let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                                windowScene?.keyWindow?.rootViewController?.present(activityViewController, animated: true)
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .padding()
                        }
                    }
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(movieDetails?.title ?? "")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(movieDetails?.genreNames ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    isFavorite.toggle()
                    viewModel.toggleFavorite(for: movie)
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                }
            }
            
            VStack(alignment: .leading) {
                Text(movieDetails?.releaseFormatedDate ?? "")
                    .font(.footnote)
                    .foregroundStyle(.orange)
                
                if let vote = movieDetails?.voteAverage {
                    FiveStartViewSwiftUI(rating: Int(vote)/2)
                        .frame(width: 150, height: 30)
                }
            }
        }.onAppear {
            isFavorite = CoreDataManager.shared.isMovieFavorite(movieID: movie.id)
        }
    }
}

#Preview {
    MovieHeaderView(movie: Movie.movieForPreview())
}

// Create a UIViewRepresentable wrapper for SkeletonView
struct SkeletonViewRepresentable: UIViewRepresentable {
    let skeletonView = UIView()

    func makeUIView(context: Context) -> UIView {
        skeletonView.isSkeletonable = true
        skeletonView.showAnimatedGradientSkeleton()
        return skeletonView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
