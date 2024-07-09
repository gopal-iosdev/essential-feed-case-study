//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/9/24.
//

import XCTest
import EssentialFeed

final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    let decoratee: FeedImageDataLoader

    public init(decoratee: FeedImageDataLoader) {
        self.decoratee = decoratee
    }

    func loadImageData(
        from url: URL,
        completion: @escaping (FeedImageDataLoader.Result) -> Void
    ) -> any EssentialFeed.FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url, completion: completion)
    }

}

final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {

    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()

        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs in the loader")
    }

    func test_loadImageData_loadsFromLoader() {
        let url = URL.anyURL
        let (sut, loader) = makeSUT()

        _ = sut.loadImageData(from: url) { _ in }

        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }

    func test_cancelLoadImageData_cancelsLoaderTask() {
        let url = URL.anyURL
        let (sut, loader) = makeSUT()

        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()

        XCTAssertEqual(loader.cancelledURLs, [url], "Expected to cancel URL loading from loader")
    }

    func test_loadImageData_deliversImageDataOnLoaderSuccess() {
        let imageData = Data.anyData
        let (sut, loader) = makeSUT()

        expect(sut: sut, toCompleteWith: .success(imageData)) {
            loader.complete(with: imageData)
        }
    }

    func test_loadImageData_deliversErrorOnPrimaryAndFallbackLoaderFailure() {
        let (sut, loader) = makeSUT()

        expect(sut: sut, toCompleteWith: .failure(NSError.anyError)) {
            loader.complete(with: NSError.anyError)
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader)

        trackMemoryLeaks(loader)
        trackMemoryLeaks(sut)

        return (sut, loader)
    }

}
