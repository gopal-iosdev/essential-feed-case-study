//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 7/9/24.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Swift.Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
