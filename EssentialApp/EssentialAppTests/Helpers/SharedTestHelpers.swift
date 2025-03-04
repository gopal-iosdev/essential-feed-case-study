//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/1/24.
//

import Foundation
import EssentialFeed

extension URL {
    static let anyURL = URL(string: "http://a-url.com")!
}

extension NSError {
    static let anyError = NSError(domain: "any error", code: 0)
}

extension Data {
    static let anyData = Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http:\\any-url.com")!)]
}

private class DummyView: ResourceView {
    func display(_ viewModel: Any) {}
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var commentsTitle: String {
    ImageCommentsPresenter.title
}
