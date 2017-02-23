//
//  RealmHelper.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmHelper {
  static let realmQueue = DispatchQueue(label: "RealmQueue")
  
  static func persistedPageCount() -> Int {
    let realm = try? Realm()
    return realm?.objects(Movie.self).max(ofProperty: "fromPage") ?? 0
  }
  
  static func fetch(from page: Int) -> [Movie] {
    let realm = try? Realm()
    let movies = realm?.objects(Movie.self).filter("fromPage == %@", page)
    return movies?.flatMap { $0 } ?? []
  }
}
