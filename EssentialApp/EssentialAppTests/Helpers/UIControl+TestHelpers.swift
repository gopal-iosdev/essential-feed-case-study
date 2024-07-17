//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Gopal Gurram on 2/29/24.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
