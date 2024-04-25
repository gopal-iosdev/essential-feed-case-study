//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 4/25/24.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        FeedErrorViewModel(message: message)
    }
}
