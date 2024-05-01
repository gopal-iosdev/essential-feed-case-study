//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Gopal Gurram on 2/22/24.
//

import UIKit
import EssentialFeed

protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    var delegate: FeedViewControllerDelegate?

    @IBOutlet private(set) public var errorView: ErrorView?

    private var onViewIsAppearing: ((FeedViewController) -> Void)?

    var tableModel = [FeedImageCellController]() {
        didSet {
            tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.refresh()
        }
    }

    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        onViewIsAppearing?(self)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

extension FeedViewController: FeedLoadingView {
    public func display(_ viewModel: FeedLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

extension FeedViewController: FeedErrorView {
    public func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
}
