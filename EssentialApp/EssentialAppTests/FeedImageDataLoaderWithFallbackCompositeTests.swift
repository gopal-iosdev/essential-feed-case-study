//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 6/30/24.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

    func test_init_doesNotLoadImageData() {
        let (_, primaryLoader, fallbackLoader) = makeSUT()

        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }

    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }

    func test_loadImageData_loadsFromFallbackLoaderOnPrimaryLoaderFailure() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        _ = sut.loadImageData(from: url) { _ in }

        primaryLoader.complete(with: NSError.anyError)

        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
        XCTAssertEqual(fallbackLoader.loadedURLs, [url], "Expected to load URL from fallback loader")
    }

    func test_cancelLoadImageData_cancelsPrimaryLoaderTask() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(primaryLoader.cancelledURLs, [url], "Expected to cancel URL loading from primary loader")
        XCTAssertTrue(fallbackLoader.cancelledURLs.isEmpty, "Expected to cancelled URL's in fallback loader")
    }

    func test_cancelLoadImageData_cancelsSecondaryLoaderTaskOnPrimaryLoaderFailure() {
        let url = anyURL()
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        let task = sut.loadImageData(from: url) { _ in }

        primaryLoader.complete(with: NSError.anyError)

        task.cancel()

        XCTAssertTrue(primaryLoader.cancelledURLs.isEmpty, "Expected to cancelled URL's in primary loader")
        XCTAssertEqual(fallbackLoader.cancelledURLs, [url], "Expected to cancel URL loading from fallback loader")
    }

    func test_loadImageData_deliversPrimaryDataOnPrimaryLoaderSuccess() {
        let primaryData = Data.anyData
        let (sut, primaryLoader, _) = makeSUT()

        expect(sut: sut, toCompleteWith: .success(primaryData)) {
            primaryLoader.complete(with: primaryData)
        }
    }

    func test_loadImageData_deliversFallbackDataOnFallbackLoaderSuccess() {
        let fallbackData = Data.anyData
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        expect(sut: sut, toCompleteWith: .success(fallbackData)) {
            primaryLoader.complete(with: NSError.anyError)
            fallbackLoader.complete(with: fallbackData)
        }
    }

    func test_loadImageData_deliversErrorOnPrimaryAndFallbackLoaderFailure() {
        let (sut, primaryLoader, fallbackLoader) = makeSUT()

        expect(sut: sut, toCompleteWith: .failure(NSError.anyError)) {
            primaryLoader.complete(with: NSError.anyError)
            fallbackLoader.complete(with: NSError.anyError)
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedImageDataLoader, primaryLoader: LoaderSpy, fallbackLoader: LoaderSpy) {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

        trackMemoryLeaks(primaryLoader)
        trackMemoryLeaks(fallbackLoader)
        trackMemoryLeaks(sut)

        return (sut, primaryLoader, fallbackLoader)
    }

    private func expect(
        sut: FeedImageDataLoader,
        toCompleteWith expectedResult: FeedImageDataLoader.Result,
        when action: () -> (Void),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load image data completion")
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed)

            case (.failure, .failure):
                break

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1.0)
    }

    private func trackMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }

    private func anyURL() -> URL {
        return URL(string: "http://a-url.com")!
    }

    private class LoaderSpy: FeedImageDataLoader {
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

        var loadedURLs: [URL] {
            messages.map{ $0.url }
        }

        private(set) var cancelledURLs = [URL]()

        private struct Task: FeedImageDataLoaderTask {
            let callback: () -> (Void)
            func cancel() {
                callback()
            }
        }

        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))

            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }

        func complete(with error: NSError, and index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(with expectedData: Data, and index: Int = 0) {
            messages[index].completion(.success(expectedData))
        }
    }

}

extension Data {
    static let anyData = Data("any data".utf8)
}
