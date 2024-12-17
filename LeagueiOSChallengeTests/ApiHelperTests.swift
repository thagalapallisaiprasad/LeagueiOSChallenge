//
//  test.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import XCTest
@testable import LeagueiOSChallenge

class APIHelperTests: XCTestCase {
  var apiHelper: APIHelper!
  
  override func setUp() {
    super.setUp()
    apiHelper = APIHelper()
    // Ensure a token is set for the test
    AppDelegate.sharedInstance.userToken = "test_token"
  }
  
  override func tearDown() {
    apiHelper = nil
    AppDelegate.sharedInstance.userToken = nil
    super.tearDown()
  }
  
  func testInvalidEndpoint() async {
    // Arrange
    let invalidURL = "Invalid_endpoint"
    
    // Act & Assert
    do {
      _ = try await apiHelper.fetchData(url: invalidURL) as [User]
      XCTFail("Should throw an error for invalid URL")
    } catch let error as APIError {
      XCTAssertEqual(error, .invalidEndpoint, "Expected APIError.invalidEndpoint but got \(error)")
    } catch let error as URLError {
      XCTAssertEqual(error.code, .unsupportedURL, "Expected URLError.unsupportedURL but got \(error.code)")
    } catch {
      XCTFail("Unexpected error type: \(type(of: error)) - \(error)")
    }
  }
}
