//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/1/24.
//

import Foundation

extension URL {
    static let anyURL = URL(string: "http://a-url.com")!
}

extension NSError {
    static let anyError = NSError(domain: "any error", code: 0)
}

extension Data {
    static let anyData = Data("any data".utf8)
}
