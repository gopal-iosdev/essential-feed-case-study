//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 2/29/24.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
