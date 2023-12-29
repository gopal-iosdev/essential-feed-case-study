//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 12/27/23.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any", location: "any", url: URL.anyURL)
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map {
        LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
    }

    return (models, local)
}

extension Date {
    private var feedCacheMaxAge: Int {
        7
    }

    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedCacheMaxAge)
    }

    private func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}
