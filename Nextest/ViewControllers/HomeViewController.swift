//
//  HomeViewController.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class HomeViewController: UIViewController {
  fileprivate let tableView: UITableView = {
    let tableView = UITableView()
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.register(MovieCell.self, forCellReuseIdentifier: NSStringFromClass(MovieCell.self))
    tableView.keyboardDismissMode = .onDrag
    return tableView
  }()
  
  fileprivate let refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    return refreshControl
  }()
  
  fileprivate let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    return searchBar
  }()
  
  fileprivate var homeViewModel = HomeViewModel()
  
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
  
  init(viewModel: HomeViewModel? = nil) {
    if let viewModel = viewModel {
      homeViewModel = viewModel
    }
    super.init(nibName: nil, bundle: nil)
    setUp()
  }
  
  private func setUp() {
    view.backgroundColor = .white
    
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    
    refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
    tableView.addSubview(refreshControl)
    
    constrain(tableView) { table in
      table.top == table.superview!.top
      table.left == table.superview!.left
      table.bottom == bottomLayoutGuideCartography
      table.right == table.superview!.right
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    if !homeViewModel.isSearchResults {
      searchBar.delegate = self
      navigationItem.titleView = searchBar
      reload()
    }
  }
}

// MARK: - Actions
extension HomeViewController {
  func reload() {
    homeViewModel = HomeViewModel()
    refresh()
  }
}

// MARK: - Private
fileprivate extension HomeViewController {
  func refresh() {
    homeViewModel = homeViewModel.load { [weak self] inner in
      self?.refreshControl.endRefreshing()
      do {
        let viewModel = try inner()
        self?.homeViewModel = viewModel
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      } catch {
        print(error)
      }
    }
    if homeViewModel.nextPage != nil {
      tableView.reloadData()
      refreshControl.endRefreshing()
    }
  }
  
  func goToDetails(movie: Movie) {
    let movieViewController = MovieViewController(movie: movie)
    navigationController?.pushViewController(movieViewController, animated: true)
  }
}

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return homeViewModel.topMovies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MovieCell.self), for: indexPath) as? MovieCell else {
      return UITableViewCell()
    }
    let movie = homeViewModel.topMovies[indexPath.row]
    
    cell.update(movie)
    return cell
  }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let movie = homeViewModel.topMovies[indexPath.row]
    goToDetails(movie: movie)
  }
}

// MARK: - UIScrollView Delegate
extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
      refresh()
    }
  }
}

// MARK: - UISearchBar Delegate
extension HomeViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text, text.characters.count > 0 else {
      return
    }
    let viewModel = homeViewModel.homeViewModel(with: text)
    let homeViewController = HomeViewController(viewModel: viewModel)
    navigationController?.pushViewController(homeViewController, animated: true)
  }
}
