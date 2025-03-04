//
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Rao Gurram on 3/3/25.
//

import XCTest

enum FeedEndpoint {
    case get
    
    func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}

final class FeedEndpointTests: XCTestCase {
    
    func test_feed_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "https://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
    }
    
}
