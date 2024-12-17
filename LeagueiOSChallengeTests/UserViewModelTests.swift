//
//  test.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import XCTest
@testable import LeagueiOSChallenge

class UserViewModelTests: XCTestCase {
  var viewModel: UserViewModel!
  var mockAPIService: MockUserAPIService!
  
  override func setUp() {
    super.setUp()
    mockAPIService = MockUserAPIService()
    viewModel = UserViewModel(apiService: mockAPIService)
  }
  
  override func tearDown() {
    viewModel = nil
    mockAPIService = nil
    super.tearDown()
  }
  
  func createMockUser(id: Int, username: String) -> User {
    return User(
      id: id,
      avatar: "https://i.pravatar.cc/150?u=Sincere@april.biz",
      name: "Saiprasad",
      username: username,
      email: "saiprasad.thagalapalli@gmail.com",
      address: Address(
        street: "",
        suite: "",
        city: "",
        zipcode: "",
        geo: Geo(lat: "", lng: "")
      ),
      phone: "",
      website: "",
      company: Company(
        name: "",
        catchPhrase: "",
        bs: ""
      )
    )
  }
  
  func testSuccessfulUserFetch() async throws {
    // Arrange
    let mockUsers = [
      createMockUser(id: 1, username: "Saiprasad"),
      createMockUser(id: 2, username: "Thagalapalli")
    ]
    let mockPosts = [
      Post(userId: 1, id: 1, title: "First Post", body: "Post content"),
      Post(userId: 2, id: 2, title: "Second Post", body: "Another post")
    ]
    mockAPIService.mockUsers = mockUsers
    mockAPIService.mockPosts = mockPosts
    
    // Act
    viewModel.fetchUsers()
    
    // Small delay to allow async operations to complete
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    
    // Assert
    XCTAssertEqual(viewModel.users.count, 2)
    XCTAssertEqual(viewModel.users.first?.username, "Saiprasad")
    XCTAssertEqual(viewModel.users.first?.address.city, "")
  }
  
  func testFailedUserFetch() async throws {
    // Arrange
    mockAPIService.shouldThrowError = true
    
    // Act
    viewModel.fetchUsers()
    
    // Small delay to allow async operations to complete
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    
    // Assert
    XCTAssertNotNil(viewModel.errorMessage)
    XCTAssertTrue(viewModel.errorMessage?.contains("Failed to load data") == true)
  }
}

// Mock APIService for testing UserViewModel
class MockUserAPIService: APIService {
  var mockUsers: [User] = []
  var mockPosts: [Post] = []
  var shouldThrowError = false
  
  func fetchUserToken(username: String, password: String) async throws -> String {
    return "mock_token"
  }
  
  func fetchData<T: Codable>(url: String) async throws -> [T] {
    if shouldThrowError {
      throw APIError.decodeFailure
    }
    
    if T.self == User.self {
      return mockUsers as! [T]
    } else if T.self == Post.self {
      return mockPosts as! [T]
    }
    
    return []
  }
}
