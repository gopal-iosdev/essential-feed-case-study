//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 2/22/24.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    private var loader: FeedLoader?

    public convenience init(loader: FeedLoader) {
        self.init()

        self.loader = loader
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)

        load()

        onViewIsAppearing = { vc in
            vc.refresh()

            vc.onViewIsAppearing = nil
        }
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        onViewIsAppearing?(self)
    }

    @objc private func refresh() {
        refreshControl?.beginRefreshing()
    }

    @objc private func load() {
        refresh()

        loader?.load{ [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
