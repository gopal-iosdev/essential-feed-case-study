//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Gopal Gurram on 2/29/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
