//
//  MovieDetailCell.swift
//  Nextest
//
//  Created by Gilson Gil on 23/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography

final class MovieDetailCell: UITableViewCell {
  fileprivate let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.textAlignment = .center
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
    backgroundColor = UIColor(white: 0, alpha: 0.7)
    addSubview(label)
    
    let margin = CGFloat(30)
    constrain(label) { label in
      label.top == label.superview!.top + margin
      label.left == label.superview!.left + margin
      label.bottom == label.superview!.bottom - margin
      label.right == label.superview!.right - margin
    }
  }
}

// MARK: - Public
extension MovieDetailCell {
  func update(_ value: String) {
    label.text = value
  }
}
