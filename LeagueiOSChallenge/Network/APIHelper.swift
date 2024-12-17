//
//  APIHelper.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import Foundation

// MARK: Network protocols
protocol APIService {
  func fetchUserToken(username: String, password: String) async throws -> String
  func fetchData<T: Codable>(url: String) async throws -> [T]
}

// MARK: Network class
class APIHelper: APIService {
  
  func fetchUserToken(username: String,password: String) async throws -> String {
    guard let url = URL(string: Constants.baseURL + APIEndpoint.login.rawValue) else {
      throw APIError.invalidEndpoint
    }
    
    let authString = "\(username):\(password)"
    let authData = Data(authString.utf8)
    let base64AuthString = "Basic \(authData.base64EncodedString())"
    let urlSessionConfig: URLSessionConfiguration = .default
    urlSessionConfig.httpAdditionalHeaders = ["Authorization": base64AuthString]
    let session = URLSession(configuration: urlSessionConfig)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    let (data, _) = try await session.data(for: URLRequest(url: url))
    
    if let results = try? decoder.decode(LoginResponse.self, from: data) {
      return results.apiKey
    } else {
      throw APIError.decodeFailure
    }
  }
  
  func fetchData< T: Codable>(url: String) async throws -> [T] {
    guard let url = URL(string: url) else {
      throw APIError.invalidEndpoint
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    guard let token = await AppDelegate.sharedInstance.userToken else {
      throw APIError.tokenDoesNotExist
    }
    request.addValue("\(token)", forHTTPHeaderField: "x-access-token")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
      let decodedPosts = try decoder.decode([T].self, from: data)
      return decodedPosts
    } catch {
      throw APIError.decodeFailure
    }
  }
}
