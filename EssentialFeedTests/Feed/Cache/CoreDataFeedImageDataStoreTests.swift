//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 6/16/24.
//

import XCTest
import EssentialFeed

final class CoreDataFeedImageDataStoreTests: XCTestCase, FeedImageDataStoreSpecs {

    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut, imageDataURL: imageDataURL)
        }
    }

    func test_retrieveImageData_deliversNotFoundStoreDataURLDoesNotMatch() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut, imageDataURL: imageDataURL)
        }
    }

    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(on: sut, imageDataURL: imageDataURL)
        }
    }

    func test_retrieveImageData_deliversLastInsertedValue() throws {
        try makeSUT { sut, imageDataURL in
            self.assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut, imageDataURL: imageDataURL)
        }
    }

    // - MARK: Helpers

    private func makeSUT(
        _ test: @escaping (CoreDataFeedStore, URL) -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        let exp = expectation(description: "Wait for operation")
        sut.perform {
            let imageDataURL = URL(string: "http://a-url.com")!
            insertFeedImage(with: imageDataURL, into: sut, file: file, line: line)
            test(sut, imageDataURL)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

func insertFeedImage(
    with url: URL,
    into sut: CoreDataFeedStore,
    file: StaticString = #file,
    line: UInt = #line
) {
    do {
        let image = LocalFeedImage(id: UUID(), description: "any", location: "any", url: url)
        try sut.insert([image], timestamp: Date())
    } catch {
        XCTFail("Failed to insert feed image with URL \(url) - error: \(error)", file: file, line: line)
    }
}
