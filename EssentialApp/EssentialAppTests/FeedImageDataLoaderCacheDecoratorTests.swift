//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/9/24.
//

import XCTest
import EssentialFeed

protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Swift.Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    let decoratee: FeedImageDataLoader
    let cache: FeedImageDataCache

    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }

    func loadImageData(
        from url: URL,
        completion: @escaping (FeedImageDataLoader.Result) -> Void
    ) -> any EssentialFeed.FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            self?.cache.save((try? result.get()) ?? Data(), for: url) { _ in }
            completion(result)
        }
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

        XCTAssertEqual(cache.messages, [.save(imageData)], "Expected to cache loaded feed on success")
    }

    // MARK: - Helpers

    private func makeSUT(
        cache: CacheSpy = .init(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)

        trackMemoryLeaks(loader)
        trackMemoryLeaks(sut)

        return (sut, loader)
    }

    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()

        enum Message: Equatable {
            case save(Data)
        }

        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data))
            completion(.success(()))
        }
    }

}
