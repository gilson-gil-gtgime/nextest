//
//  testMovie.swift
//  Nextest
//
//  Created by Gilson Gil on 23/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import XCTest
@testable import Nextest

class testMovie: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testFilterTop() {
    var movies = [Movie]()
    for i in 0...20 {
      let movie = Movie()
      movie.id = i
      movie.vote_average = Float(arc4random() % 100) / 10
      movies.append(movie)
    }
    let filteredMovies = movies.filterTop()
    filteredMovies.forEach { movie in
      assert(movie.vote_average > 5)
    }
  }
  
//  func filter(with query: String) -> [Movie] {
//    var movies = [Movie]()
//    for i in 0...20 {
//      let movie = Movie()
//      movie.id = i
//      movie.title = Float(arc4random() % 100) / 100
//      movies.append(movie)
//    }
//    let filteredMovies = movies.filterTop()
//    filteredMovies.forEach {
//      assert($0.vote_average < 5)
//    }
//    return filter { $0.title.localizedCaseInsensitiveContains(query) }
//  }

}
