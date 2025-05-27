//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 2/29/24.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
