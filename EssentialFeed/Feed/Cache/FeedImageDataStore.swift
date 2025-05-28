//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 6/14/24.
//

import Combine
import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
