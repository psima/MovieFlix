//
//  PosterTableViewCell.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 25/2/25.
//

import UIKit

class PosterTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieThumView: UIImageView!
    @IBOutlet weak var fiveStarsView: FiveStarView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    private var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        movieThumView.image = nil // Reset image
        movieThumView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 5
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor.orange.cgColor
        titleView.textColor = .white
        
        movieThumView.showAnimatedGradientSkeleton() 
        self.contentView.isSkeletonable = true
        
        // Add gradient color
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.cgColor
        ]
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.backgroundColor = .clear
    }
    
    private func setupFavorite(movieId: Int) {
        let isFavorite = CoreDataManager.shared.isMovieFavorite(movieID: movieId)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .red : .gray
    }
    
    func configure(with movie: Movie) {
        self.movie = movie
        titleView.text = movie.title
        releaseDateLabel.text = formatDate(from: movie.releaseDate)
        movieThumView.image = nil // Reset image
        movieThumView.showAnimatedSkeleton()
        setupFavorite(movieId: movie.id)
        if let posterPath = movie.posterPath {
            
            let posterURL = "\(Constants.imageURLString)\(posterPath)"
            self.tag = posterURL.hashValue
            AsyncImageLoader.shared.loadImage(from: posterURL) { image in
                guard let image = image else { return }
                if self.tag == posterURL.hashValue {
                    self.movieThumView.image = image
                }
            }
        }
        fiveStarsView.rating = Int(movie.voteAverage/2)
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        if let movie = movie {
            if CoreDataManager.shared.isMovieFavorite(movieID: movie.id) {
                CoreDataManager.shared.removeMovieFromFavorites(movieID: movie.id)
            } else {
                CoreDataManager.shared.saveMovieAsFavorite(movie)
            }
            
            setupFavorite(movieId: movie.id)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
