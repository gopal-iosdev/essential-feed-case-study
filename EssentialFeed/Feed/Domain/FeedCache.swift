//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 7/9/24.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
