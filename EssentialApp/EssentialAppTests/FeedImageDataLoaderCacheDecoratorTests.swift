//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/9/24.
//

import XCTest
import EssentialFeed
import EssentialApp

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

    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let imageData = Data.anyData
        let (sut, loader) = makeSUT()

        expect(sut: sut, toCompleteWith: .success(imageData)) {
            loader.complete(with: imageData)
        }
    }

    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let (sut, loader) = makeSUT()

        expect(sut: sut, toCompleteWith: .failure(NSError.anyError)) {
            loader.complete(with: NSError.anyError)
        }
    }

    func test_loadImageData_cachesLoadedDataOnLoaderSuccess() {
        let url = URL.anyURL
        let imageData = Data.anyData
        let cache = CacheSpy()
        let (sut, loader) = makeSUT(cache: cache)

        _ = sut.loadImageData(from: url) { _ in }
        loader.complete(with: imageData)

        XCTAssertEqual(cache.messages, [.save(imageData)], "Expected to cache loaded image data on success")
    }

    func test_loadImageData_doesNotCacheOnLoaderFailure() {
        let url = URL.anyURL
        let cache = CacheSpy()
        let (sut, loader) = makeSUT(cache: cache)

        _ = sut.loadImageData(from: url) { _ in }
        loader.complete(with: NSError.anyError)

        XCTAssertTrue(cache.messages.isEmpty, "Expected not to cache image data on load error")
    }

    // MARK: - Helpers

    private func makeSUT(
        cache: CacheSpy = .init(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
    }

    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()

        enum Message: Equatable {
            case save(Data)
        }

        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
    }

}
