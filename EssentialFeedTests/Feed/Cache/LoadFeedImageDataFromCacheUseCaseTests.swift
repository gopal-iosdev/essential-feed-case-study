//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 6/9/24.
//

import XCTest
import EssentialFeed

final class LoadFeedImageDataFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_loadImageDataFromURL_requestsStoredDataFromURL() {
        let (sut, store) = makeSUT()
        let url = URL.anyURL

        _ = try? sut.loadImageData(from: url)

        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }

    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: failed(), when: {
            let retrievalError = NSError.anyError
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: notFound(), when: {
            store.completeRetrieval(with: .none)
        })
    }

    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSUT()
        let foundData = Data.anyData

        expect(sut, toCompleteWith: .success(foundData), when: {
            store.completeRetrieval(with: foundData)
        })
    }

    // MARK: - Helpers

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func failed() -> Result<Data, Error> {
        .failure(LocalFeedImageDataLoader.LoadError.failed)
    }

    private func notFound() -> Result<Data, Error> {
        .failure(LocalFeedImageDataLoader.LoadError.notFound)
    }

    private func never(file: StaticString = #file, line: UInt = #line) {
        XCTFail("Expected no no invocations", file: file, line: line)
    }

    private func expect(
        _ sut: LocalFeedImageDataLoader,
        toCompleteWith expectedResult: Result<Data, Error>,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        action()
        
        let receivedResult = Result { try sut.loadImageData(from: URL.anyURL) }

        switch(receivedResult, expectedResult) {
        case let (.success(receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let receivedError as LocalFeedImageDataLoader.LoadError), .failure(let expectedError as LocalFeedImageDataLoader.LoadError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
