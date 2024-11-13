//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 4/26/24.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}
