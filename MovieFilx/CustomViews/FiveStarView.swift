//
//  FiveStarView.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 25/2/25.
//

import UIKit

class FiveStarView: UIView {

    // MARK: - Properties

    private var stackView: UIStackView!
    private var stars: [UIImageView] = []
    public var rating: Int = 0 {
        didSet {
            updateStarAppearance()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2

        // Create image views for stars
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            stars.append(imageView)
            stackView.addArrangedSubview(imageView)
        }

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        updateStarAppearance()
    }

    // MARK: - Star Appearance

    private func updateStarAppearance() {
        for (index, imageView) in stars.enumerated() {
            if index < rating {
                imageView.image = UIImage(named: "star_fill")
            } else {
                imageView.image = UIImage(named: "star_empty")
            }
        }
    }
}
