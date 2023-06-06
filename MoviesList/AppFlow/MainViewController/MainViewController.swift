//
//  ViewController.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import UIKit
import KRProgressHUD

final class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    // MARK: - Private variables
    private var refreshControl = UIRefreshControl()
    private let viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
        
        Task {
            await self.fetchMovies()
        }
    }
    
    @objc func fetchMovies() async {
        await viewModel.composeMovies()
    }
}

extension MainViewController {
    
    fileprivate func setupUI() {
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 240
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
        
        self.tableView.registerCellNib(MovieCell.self)
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self,
                                 action: #selector(fetchMovies),
                                 for: .valueChanged)
        
        self.title = "Discover New Movies"
        
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.delegate = viewModel
    }
    
    fileprivate func bind() {
        
        self.viewModel.movies.bind { [weak self] movies in
            mainThread {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                KRProgressHUD.dismiss()
            }
        }
        
        self.viewModel.currentMovieId.bind { movieId in
            guard let id = movieId else { return }
            let detailsVC = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
            detailsVC.movieId = id
            self.searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
