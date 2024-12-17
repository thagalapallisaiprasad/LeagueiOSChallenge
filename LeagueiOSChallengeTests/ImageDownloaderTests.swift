//
//  test.swift
//  LeagueiOSChallenge
//
//  Created by Saiprasad on 17/12/24.
//

import XCTest
@testable import LeagueiOSChallenge

class ImageDownloaderTests: XCTestCase {
    func testValidImageDownload() {
        // Arrange
        let expectation = XCTestExpectation(description: "Image Downloaded")
        let validImageURL = "https://i.pravatar.cc/150?u=Sincere@april.biz"
        
        // Act
        ImageDownloader.downloadImage(from: validImageURL) { image in
            // Assert
            XCTAssertNotNil(image, "Image should be downloaded successfully")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testInvalidImageURL() {
        // Arrange
        let expectation = XCTestExpectation(description: "Invalid Image URL")
        let invalidImageURL = "invalid_url"
        
        // Act
        ImageDownloader.downloadImage(from: invalidImageURL) { image in
            // Assert
            XCTAssertNil(image, "Image should be nil for invalid URL")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
