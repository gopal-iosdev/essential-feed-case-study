//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 4/15/23.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>

    func load(completion: @escaping (Result) -> (Void))
}
