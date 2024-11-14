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

extension Data {
    static let anyData = Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}


extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(
            url: URL.anyURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
    
    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        calendar.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        calendar.date(byAdding: .day, value: days, to: self)!
    }
}
