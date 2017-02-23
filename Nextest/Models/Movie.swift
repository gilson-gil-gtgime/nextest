//
//  Movie.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

final class Movie: Object {
  fileprivate let imagesBaseUrl = "https://image.tmdb.org/t/p/w300/"
  
  dynamic var title: String = ""
  dynamic var id: Int = 0
  dynamic var overview: String = ""
  dynamic var poster_path: String = ""
  dynamic var release_date: String = ""
  dynamic var vote_average: Float = 0
  dynamic var fromPage: Int = 1
  
  var posterUrl: String {
    return imagesBaseUrl + poster_path
  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  static func create(_ json: [String: AnyObject], from page: Int) -> Movie? {
    guard let id = json["id"] as? Int, let title = json["title"] as? String, let vote_average = json["vote_average"] as? Float else {
      return nil
    }
    let movie: Movie
    let realm = try? Realm()
    if let aMovie = realm?.object(ofType: Movie.self, forPrimaryKey: id) {
      movie = aMovie
    } else {
      movie = Movie()
      movie.id = id
    }
    try? realm?.write {
      movie.title = title
      movie.overview = json["overview"] as? String ?? ""
      movie.poster_path = json["poster_path"] as? String ?? ""
      movie.release_date = json["release_date"] as? String ?? ""
      movie.vote_average = vote_average
      movie.fromPage = page
      realm?.add(movie, update: true)
    }
    return movie
  }
}

extension Array where Element:Movie {
  func filterTop() -> [Movie] {
    return filter { $0.vote_average > Constants.minimumRating }
  }
  
  func filter(with query: String) -> [Movie] {
    return filter { $0.title.localizedCaseInsensitiveContains(query) }
  }
}
