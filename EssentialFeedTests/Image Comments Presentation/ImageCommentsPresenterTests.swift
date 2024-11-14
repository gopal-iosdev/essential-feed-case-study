//
//  ImageCommentsPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Rao Gurram on 11/13/24.
//

import XCTest
import EssentialFeed

final class ImageCommentsPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
    func test_map_createsViewModels() {
        let now = Date()
        
        let comments = [
            ImageComment(id: UUID(), message: "a message", createdAt: now.adding(minutes: -5), username: "a username"),
            ImageComment(id: UUID(), message: "another message", createdAt: now.adding(days: -1), username: "another username")
        ]
        
        let viewModel = ImageCommentsPresenter.map(comments)
        
        XCTAssertEqual(
            viewModel.comments,
            [
                ImageCommentViewModel(message: "a message", date: "5 minutes ago", username: "a username"),
                ImageCommentViewModel(message: "another message", date: "1 day ago", username: "another username")
            ]
        )
    }

    // MARK: - Helpers

    private func localized(
        _ key: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }

        return value
    }

}
