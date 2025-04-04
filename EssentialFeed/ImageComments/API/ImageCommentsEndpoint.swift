//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Gopal Rao Gurram on 3/3/25.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(let id):
            return baseURL.appendingPathComponent("/v1/image/\(id.uuidString)/comments")
        }
    }
}
