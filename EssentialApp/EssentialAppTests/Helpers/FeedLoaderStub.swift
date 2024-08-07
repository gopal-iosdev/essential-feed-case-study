//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/8/24.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> (Void)) {
        completion(result)
    }
}
