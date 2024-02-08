//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Gopal Gurram on 11/29/23.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
