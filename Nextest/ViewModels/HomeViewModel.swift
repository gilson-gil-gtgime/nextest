//
//  HomeViewModel.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Alamofire

struct HomeViewModel {
  let movies: [Movie]
  let topMovies: [Movie]
  let nextPage: Int?
  let isSearchResults: Bool
  
  init(movies: [Movie] = [], nextPage: Int? = 1, isSearchResults: Bool = false) {
    self.movies = movies
    self.topMovies = movies.filterTop()
    self.nextPage = nextPage
    self.isSearchResults = isSearchResults
  }
  
  func load(_ completion: @escaping (_ inner: () throws -> HomeViewModel) -> ()) -> HomeViewModel {
    guard let nextPage = nextPage else {
      return self
    }
    guard nextPage > RealmHelper.persistedPageCount() else {
      print("from local data")
      let movies = RealmHelper.fetch(from: nextPage)
      let viewModel = HomeViewModel(movies: self.movies + movies, nextPage: nextPage + 1, isSearchResults: false)
      return viewModel
    }
    Alamofire.request(APIRouter.nowPlaying(page: nextPage))
    .responseJSON { response in
      switch response.result {
      case .success(let value):
        guard let json = value as? [String: AnyObject] else {
          return
        }
        let moviesJson = json["results"] as? [[String: AnyObject]]
        let movies = moviesJson?.flatMap {
          Movie.create($0, from: nextPage)
        } ?? []
        let totalPages = json["total_pages"] as? Int
        let nPage: Int?
        if let tPages = totalPages, tPages > nextPage {
          nPage = nextPage + 1
        } else {
          nPage = nil
        }
        let viewModel = HomeViewModel(movies: self.movies + movies, nextPage: nPage)
        completion { return viewModel }
      case .failure(let error):
        completion { throw error }
      }
    }
    let viewModel = HomeViewModel(movies: self.movies, nextPage: nil)
    return viewModel
  }
  
  func homeViewModel(with searchTerm: String) -> HomeViewModel {
    let filteredMovies = movies.filter(with: searchTerm)
    let viewModel = HomeViewModel(movies: filteredMovies, nextPage: nil, isSearchResults: true)
    return viewModel
  }
}
