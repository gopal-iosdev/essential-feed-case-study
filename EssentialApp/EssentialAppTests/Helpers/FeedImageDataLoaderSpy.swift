//
//  FeedImageDataLoaderSpy.swift
//  EssentialAppTests
//
//  Created by Gopal Gurram on 7/9/24.
//

import EssentialFeed

class FeedImageDataLoaderSpy: FeedImageDataLoader {
    private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()

    var loadedURLs: [URL] {
        messages.map{ $0.url }
    }

    private(set) var cancelledURLs = [URL]()

    private struct Task: FeedImageDataLoaderTask {
        let callback: () -> (Void)
        func cancel() {
            callback()
        }
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        messages.append((url, completion))

        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }

    func complete(with error: NSError, and index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(with expectedData: Data, and index: Int = 0) {
        messages[index].completion(.success(expectedData))
    }
}
