//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Rao Gurram on 11/13/24.
//

import XCTest
import EssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeyAndValuesExists(in: bundle, table)
    }
    
}
