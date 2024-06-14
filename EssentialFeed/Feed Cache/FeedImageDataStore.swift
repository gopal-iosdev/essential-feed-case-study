//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 6/14/24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
