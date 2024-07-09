//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 7/9/24.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
