//
//  ViewController.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 25/2/25.
//

import UIKit
import SwiftUI
import SkeletonView

class ViewController: UIViewController {

    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    private var cellIdentifier = "PosterTableViewCell"
    var viewModel = HomeViewModel()
    private var searchQuery = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Observe when movies array is updated
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
                self?.moviesTableView.refreshControl?.endRefreshing()
            }
        }
        viewModel.fetchPopularMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.moviesTableView.reloadData() // Need this if favorite is setted in the details page
    }
    
    private func setupUI() {
        self.moviesTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        searchBarView.delegate = self
        searchBarView.isUserInteractionEnabled = true

        // Add pull-to-refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        moviesTableView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        viewModel.currentPage = 1 // Reset page
        viewModel.movies = [] // Reset array of movies
        if viewModel.isSearching {
            viewModel.searchMovies(query: searchQuery) // Refresh search results
        } else {
            viewModel.fetchPopularMovies() // Refresh popular movies
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PosterTableViewCell", for: indexPath) as! PosterTableViewCell
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 1 && !viewModel.isLoading { // Check if not already loading
            viewModel.currentPage += 1
            if viewModel.isSearching {
                viewModel.searchMovies(query: searchQuery) // Load next page of search results
            } else {
                viewModel.fetchPopularMovies() // Load next page of popular movies
            }
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]

        // Create a SwiftUI view and embed it in a UIHostingController
        let detailsView = MovieDetailView(movie: movie)
        let hostingController = UIHostingController(rootView: detailsView)

        // Push the SwiftUI view onto the navigation stack
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.isSearching = false
            viewModel.currentPage = 1
            viewModel.movies = []
            moviesTableView.reloadData()
            viewModel.fetchPopularMovies() // Revert to popular movies
        } else {
            searchQuery = searchText
            viewModel.searchMovies(query: searchText)
        }
    }
}

