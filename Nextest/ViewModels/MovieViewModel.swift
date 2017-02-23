//
//  MovieViewModel.swift
//  Nextest
//
//  Created by Gilson Gil on 23/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

struct MovieViewModel {
  let posterUrl: String
  let details: [String]
  
  init(movie: Movie) {
    posterUrl = movie.posterUrl
    details = [
      movie.title,
      movie.overview,
      "Release date\n \(movie.release_date)",
      String(format: "Rating\n %.1f", arguments: [movie.vote_average])
    ]
  }
}
