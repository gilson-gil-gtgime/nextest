//
//  MovieCell.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

final class MovieCell: UITableViewCell {
  fileprivate let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    return imageView
  }()
  
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .black
    label.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
    return label
  }()
  
  fileprivate let ratingLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .red
    label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
    label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
    return label
  }()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUp()
  }
  
  private func setUp() {
    backgroundColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 235 / 255, alpha: 1)
    
    addSubview(posterImageView)
    addSubview(titleLabel)
    addSubview(ratingLabel)
    
    let margin = CGFloat(20)
    constrain(posterImageView, titleLabel, ratingLabel) { poster, title, rating in
      poster.top == poster.superview!.topMargin
      poster.left == poster.superview!.leftMargin
      poster.bottom == poster.superview!.bottomMargin
      poster.width == 60
      poster.height == 100
      
      title.top >= title.superview!.top + margin
      title.left == poster.right + margin
      title.bottom <= title.superview!.bottom - margin
      title.centerY == title.superview!.centerY
      
      rating.left == title.right + margin
      rating.right == rating.superview!.right - margin
      rating.centerY == rating.superview!.centerY
    }
  }
}

// MARK: - Public
extension MovieCell {
  func update(_ movie: Movie) {
    posterImageView.image = nil
    titleLabel.text = movie.title
    ratingLabel.text = String(format: "%.1f", arguments: [movie.vote_average])
    if let url = URL(string: movie.posterUrl) {
      let imageResource = ImageResource(downloadURL: url)
      posterImageView.kf.setImage(with: imageResource)
    }
  }
}
