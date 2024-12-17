//
//  PostListViewModelProtocol.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//
import Foundation
import Combine

// MARK: UserViewModel
class UserViewModel: ObservableObject {
  @Published private(set) var users: [User] = []
  @Published private(set) var posts: [Post] = []
  @Published private(set) var errorMessage: String? = nil
  private let apiService: APIService
  
  init(apiService: APIService = APIHelper()) {
    self.apiService = apiService
  }
  
  // fetch the user list api and posts api at once to display the user data
  func fetchUsers() {
    Task {
      do {
        let fetchedUsers: [User] = try await apiService.fetchData(url: Constants.baseURL + APIEndpoint.users.rawValue)
        self.users = fetchedUsers
      } catch {
        self.errorMessage = "Failed to load data: \(error.localizedDescription)"
      }
      
      do {
        let fetchedPosts: [Post] = try await apiService.fetchData(url: Constants.baseURL + APIEndpoint.posts.rawValue)
        self.posts = fetchedPosts
      } catch {
        self.errorMessage = "Failed to load data: \(error.localizedDescription)"
      }
    }
  }
}
