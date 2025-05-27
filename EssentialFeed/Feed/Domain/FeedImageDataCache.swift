//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 7/9/24.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
