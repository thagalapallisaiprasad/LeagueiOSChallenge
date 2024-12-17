//
//  test.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import XCTest
@testable import LeagueiOSChallenge

class LoginViewModelTests: XCTestCase {
  var viewModel: LoginViewModel!
  var mockAPIService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    mockAPIService = MockAPIService()
    viewModel = LoginViewModel(apiService: mockAPIService)
  }
  
  override func tearDown() {
    viewModel = nil
    mockAPIService = nil
    super.tearDown()
  }
  
  func testSuccessfulLogin() async throws {
    // Arrange
    mockAPIService.mockUserToken = "test_token"
    
    // Act
    viewModel.login(username: "validuser", password: "validpassword")
    
    // Small delay to allow async operations to complete
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    
    // Assert
    XCTAssertEqual(viewModel.userToken, "test_token")
  }
  
  func testEmptyCredentialsLogin() {
    // Arrange
    viewModel.login(username: "", password: "")
    
    // Assert
    XCTAssertEqual(viewModel.errorMessage, "Please enter both username and password.")
  }
  
  func testGuestLogin() async throws {
    // Arrange
    mockAPIService.mockUserToken = "guest_token"
    
    // Act
    viewModel.continueAsGuest()
    
    // Small delay to allow async operations to complete
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    
    // Assert
    XCTAssertEqual(viewModel.userToken, "guest_token")
  }
}

// Mock APIService for testing
class MockAPIService: APIService {
  var mockUserToken: String?
  var shouldThrowError = false
  
  func fetchUserToken(username: String, password: String) async throws -> String {
    if shouldThrowError {
      throw APIError.decodeFailure
    }
    return mockUserToken ?? ""
  }
  
  func fetchData<T: Codable>(url: String) async throws -> [T] {
    // Return mock data or empty array
    return []
  }
}
