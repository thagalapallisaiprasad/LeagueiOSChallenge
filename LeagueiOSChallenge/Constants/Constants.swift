//
//  Constants.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//
import Foundation

// MARK: Application constants
struct Constants {
  static let baseURL = "https://engineering.league.dev/challenge/api/"
}

// MARK: API error validation
enum APIError: Error {
  case invalidEndpoint
  case decodeFailure
  case tokenDoesNotExist
}

// MARK: API endpoints
enum APIEndpoint: String {
  case login = "login"
  case posts = "posts"
  case users = "users"
}
