//
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/8/24.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedLoaderCacheDecoratorTests: XCTestCase, FeedLoaderTestCase {

    func test_load_deliversFeedOnSuccess() {
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed))

        expect(sut, toCompleteWith: .success(feed))
    }

    func test_load_deliversErrorOnLoaderFailure() {
        let sut = makeSUT(loaderResult: .failure(NSError.anyError))

        expect(sut, toCompleteWith: .failure(NSError.anyError))
    }

    func test_load_cachesLoadedFeedOnLoaderSuccess() {
        let cache = CacheSpy()
        let feed = uniqueFeed()
        let sut = makeSUT(loaderResult: .success(feed), cache: cache)

        sut.load { _ in }

        XCTAssertEqual(cache.messages, [.save(feed)], "Expected to cache loaded feed on success")
    }

    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let sut = makeSUT(loaderResult: .failure(NSError.anyError), cache: cache)

        sut.load { _ in }

        XCTAssertEqual(cache.messages, [], "Expected not to cache feed on load error")
    }

    // MARK: - Helpers

    private func makeSUT(
        loaderResult: FeedLoader.Result,
        cache: CacheSpy = .init(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> FeedLoader {
        let loader = FeedLoaderStub(result: loaderResult)
        let sut = FeedLoaderCacheDecorator(decoratee: loader, cache: cache)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }

    private class CacheSpy: FeedCache {
        private(set) var messages = [Message]()

        enum Message: Equatable {
            case save([FeedImage])
        }

        func save(_ feed: [EssentialFeed.FeedImage], completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(feed))
            completion(.success(()))
        }
    }

}
