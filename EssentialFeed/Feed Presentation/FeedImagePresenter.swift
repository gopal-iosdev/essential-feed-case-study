//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 4/26/24.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
