//
//  UIView+Container.swift
//  EssentialFeediOS
//
//  Created by Gopal Rao Gurram on 12/24/24.
//

import UIKit

extension UIView {
    public func makeContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return container
    }
}
