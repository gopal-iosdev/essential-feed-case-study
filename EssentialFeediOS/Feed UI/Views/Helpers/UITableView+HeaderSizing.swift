//
//  UITableView+HeaderSizing.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 7/21/24.
//

import UIKit

extension UITableView {
    func sizeTableViewHeaderToFit() {
        guard let header = tableHeaderView else { return }

        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
