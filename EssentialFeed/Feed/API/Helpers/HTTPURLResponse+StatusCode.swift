//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 6/5/24.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
