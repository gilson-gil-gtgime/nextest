//
//  MovieViewController.swift
//  Nextest
//
//  Created by Gilson Gil on 23/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

final class MovieViewController: UIViewController {
  fileprivate let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  fileprivate let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.separatorColor = UIColor(white: 0.5, alpha: 1)
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.allowsSelection = false
    tableView.register(MovieDetailCell.self, forCellReuseIdentifier: NSStringFromClass(MovieDetailCell.self))
    return tableView
  }()
  
  fileprivate let movieViewModel: MovieViewModel
  
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
  
  init(movie: Movie) {
    movieViewModel = MovieViewModel(movie: movie)
    super.init(nibName: nil, bundle: nil)
    setUp()
  }
  
  private func setUp() {
    view.addSubview(backgroundImageView)
    view.addSubview(tableView)
    
    tableView.dataSource = self
    
    constrain(backgroundImageView, tableView) { bg, table in
      bg.top == topLayoutGuideCartography
      bg.left == bg.superview!.left
      bg.bottom == bottomLayoutGuideCartography
      bg.right == bg.superview!.right
      
      table.top == table.superview!.top
      table.left == table.superview!.left
      table.bottom == table.superview!.bottom
      table.right == table.superview!.right
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let url = URL(string: movieViewModel.posterUrl) {
      let imageResource = ImageResource(downloadURL: url)
      backgroundImageView.kf.setImage(with: imageResource)
    }
    tableView.contentInset = UIEdgeInsets(top: view.bounds.height * 0.9, left: 0, bottom: 0, right: 0)
  }
}

// MARK: - UITableView DataSource
extension MovieViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieViewModel.details.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MovieDetailCell.self), for: indexPath) as? MovieDetailCell else {
      return UITableViewCell()
    }
    let value = movieViewModel.details[indexPath.row]
    cell.update(value)
    return cell
  }
}
