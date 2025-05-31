//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 11/13/23.
//

import XCTest
import EssentialFeed

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = NSError.anyError
        store.completeDeletion(with: deletionError)

        try? sut.save(uniqueImageFeed().models)

        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }

    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let timestamp = Date()
        let feed = uniqueImageFeed()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        store.completeDeletionSuccessfully()
        
        try? sut.save(feed.models)

        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed, .insert(feed.local, timestamp)])
    }

    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = NSError.anyError

        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = NSError.anyError

        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }

    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }

    // MARK: - Helpers

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, store)
    }

    private func expect(
        _ sut: LocalFeedLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        action()
        
        var receivedError: NSError?
        
        do {
            try sut.save([uniqueImage()])
        } catch {
            receivedError = error as NSError?
        }
        
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
    }
}
