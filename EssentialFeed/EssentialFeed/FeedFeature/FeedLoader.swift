//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 4/15/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> (Void))
}
