//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Gopal Gurram on 6/19/24.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import CoreData
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    private lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathExtension("feed-store.sqlite")
        )
    }()

    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var remoteFeedLoader = httpClient.getPublisher(url: URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!)
        .tryMap(FeedItemsMapper.map)

    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()

        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeLocalImageLoaderWithRemoteFallback
            )
        )
        
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
        remoteFeedLoader
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url)
            })
    }
}
