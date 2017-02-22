//
//  HomeViewController.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setUp()
  }
  
  private func setUp() {
    view.backgroundColor = .white
  }
}
