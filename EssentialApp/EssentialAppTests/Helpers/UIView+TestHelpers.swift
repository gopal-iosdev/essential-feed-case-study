//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/23/24.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}
