//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 3/25/24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        dequeueReusableCell(withIdentifier: String(describing: T.self)) as! T
    }
}
