//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Gopal Gurram on 7/13/24.
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {

    func test_onLaunch_displayRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()

        app.launch()

        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }

}
