//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 4/25/24.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {

    }
}

final class FeedImagePresenterTests: XCTestCase {

    func test_init_doesNotSentMessagesToView() {
        let view = ViewSpy()

        _ = FeedImagePresenter(view: view)

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    // MARK: - Helpers

    private class ViewSpy {
        let messages = [Any]()
    }
}
