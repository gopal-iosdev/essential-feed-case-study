//
//  UIViewController+Snapshot.swift
//  EssentialFeediOSTests
//
//  Created by Gopal Gurram on 7/21/24.
//

import UIKit

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone15Pro(
        style: UIUserInterfaceStyle,
        contentSize: UIContentSizeCategory = .medium
    ) -> SnapshotConfiguration {
        SnapshotConfiguration(
            size: CGSize(width: 430, height: 932),
            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 47, left: 16, bottom: 34, right: 16),
            traitCollection: iPhone15ProTraitCollection(
                for: style,
                contentSize: contentSize
            )
        )
    }

    private static func iPhone15ProTraitCollection(
        for style: UIUserInterfaceStyle,
        contentSize: UIContentSizeCategory
    ) -> UITraitCollection {
        UITraitCollection { traits in
            traits.forceTouchCapability = .available
            traits.layoutDirection = .leftToRight
            traits.preferredContentSizeCategory = contentSize
            traits.userInterfaceIdiom = .phone
            traits.horizontalSizeClass = .compact
            traits.verticalSizeClass = .regular
            traits.displayScale = 3
            traits.displayGamut = .P3
            traits.userInterfaceStyle = style
        }
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone15Pro(style: .light)

    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }

    override var safeAreaInsets: UIEdgeInsets {
        configuration.safeAreaInsets
    }

    override var traitCollection: UITraitCollection {
        configuration.traitCollection
    }

    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}
