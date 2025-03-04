//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Gopal Rao Gurram on 3/3/25.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
