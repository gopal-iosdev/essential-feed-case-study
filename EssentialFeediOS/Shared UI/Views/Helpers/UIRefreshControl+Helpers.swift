//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 4/23/24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
