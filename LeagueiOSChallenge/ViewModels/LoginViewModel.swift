//
//  LoginViewModel.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import Combine
import Foundation

// MARK: LoginViewModel
class LoginViewModel: ObservableObject {
  @Published private(set) var errorMessage: String?
  private let apiService: APIService
  private var cancellables = Set<AnyCancellable>()
  @Published private(set) var userToken: String?
  @Published var users: [User] = []
  @Published var posts: [Post] = []
  
  init(apiService: APIService = APIHelper()) {
    self.apiService = apiService
  }
  
  // Login with username and password
  func login(username: String, password: String) {
    if username.isEmpty || password.isEmpty {
      errorMessage = "Please enter both username and password."
    } else {
      Task {
        do {
          userToken = try await apiService.fetchUserToken(username: username, password: password)
          DispatchQueue.main.async {
            AppDelegate.sharedInstance.userToken = self.userToken
          }
        } catch {
          errorMessage = APIError.decodeFailure.localizedDescription
        }
      }
    }
  }
  
  // Login as Guest
  func continueAsGuest() {
    Task {
      do {
        userToken = try await apiService.fetchUserToken(username: "", password: "")
        DispatchQueue.main.async {
          AppDelegate.sharedInstance.userToken = self.userToken
        }
      } catch {
        errorMessage = APIError.decodeFailure.localizedDescription
      }
    }
  }
}
