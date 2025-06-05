//
//  InMemoryFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Rao Gurram on 6/5/25.
//

import XCTest
import EssentialFeed

class InMemoryFeedImageDataStoreTests: XCTestCase, FeedImageDataStoreSpecs {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversNotFoundOnEmptyCache(on: sut)
    }
    
    func test_retrieveImageData_deliversNotFoundStoreDataURLDoesNotMatch() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(on: sut)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() throws {
        let sut = makeSUT()
        
        assertThatRetrieveImageDataDeliversLastInsertedValueForURL(on: sut)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> InMemoryFeedStore {
        let sut = InMemoryFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
