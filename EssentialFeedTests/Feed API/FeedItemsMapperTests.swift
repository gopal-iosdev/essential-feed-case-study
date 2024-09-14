//
//  FeedItemsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 4/24/23.
//

import XCTest
import EssentialFeed

final class FeedItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        try samples.forEach({ code in
            let json = makeItemsJSON([])
            
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        })
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://a-url.com")!)
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "http://url.com")!)

        let items = [item1.model, item2.model]
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, items)
    }

    // MARK: - Helpers

    private func makeItem(
        id: UUID,
        description: String? = nil,
        location: String? = nil,
        imageURL: URL
    ) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)

        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ].compactMapValues { $0 }

        return (item, json)
    }
}
