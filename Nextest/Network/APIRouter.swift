//
//  APIRouter.swift
//  Nextest
//
//  Created by Gilson Gil on 22/02/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
  private static let baseURLString = Constants.tmdbBaseUrl
  private static let apiKey = Constants.tmdbApiKey
  private static let contentType = "application/json"
  
  case nowPlaying(page: Int)
  
  func asURLRequest() throws -> URLRequest {
    let method: HTTPMethod = {
      switch self {
      case .nowPlaying:
        return .get
      }
    }()
    
    let path: String = {
      switch self {
      case .nowPlaying:
        return "movie/now_playing"
      }
    }()
    
    let parameters: Parameters? = {
      switch self {
      case .nowPlaying(let page):
        return ["api_key": APIRouter.apiKey, "language": "en-US", "page": page]
      }
    }()
    
    let encoding: ParameterEncoding = {
      switch self {
      case .nowPlaying:
        return URLEncoding.queryString
      }
    }()
    
    do {
      let url = try APIRouter.baseURLString.asURL().appendingPathComponent(path)
      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = method.rawValue
      urlRequest.addValue(APIRouter.contentType, forHTTPHeaderField: "Content-Type")
      
      return try encoding.encode(urlRequest, with: parameters)
    } catch {
      throw error
    }
  }
}

protocol NextestError: Error {
  func localizedDescription() -> String
}

enum NetworkError: NextestError {
  case custom(String)
  case unexpectedReturnType
  
  init(_ message: String) {
    self = .custom(message)
  }
  
  func localizedDescription() -> String {
    switch self {
    case .custom(let message):
      return message
    default:
      return "unknown error"
    }
  }
}
