//
//  ListSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Gopal Rao Gurram on 11/21/24.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class ListSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()

        sut.display(emptyFeed())

        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a \nmulti-line\nerror message"))

        assert(
            snapshot: sut.snapshot(for: .iPhone(style: .light)),
            named: "LIST_WITH_ERROR_MESSAGE_light"
        )
        assert(
            snapshot: sut.snapshot(for: .iPhone(style: .dark)),
            named: "LIST_WITH_ERROR_MESSAGE_dark"
        )
        assert(
            snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .extraExtraExtraLarge)),
            named: "LIST_WITH_ERROR_MESSAGE_light_extraExtraExtraLarge"
        )
    }
    
    // MARK: - Helpers

    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyFeed() -> [CellController] {
        []
    }
}
