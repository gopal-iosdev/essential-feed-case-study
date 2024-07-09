//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 7/9/24.
//

import Foundation

public protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Swift.Error>

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
