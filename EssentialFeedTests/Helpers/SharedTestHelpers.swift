//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 12/27/23.
//

import Foundation

extension NSError {
    static let anyError = NSError(domain: "any error", code: 0)
}

extension URL {
    static let anyURL = URL(string: "https://any-url.com")!
}
