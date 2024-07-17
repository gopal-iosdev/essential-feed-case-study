//
//  DebuggingSceneDelegate.swift
//  EssentialApp
//
//  Created by Gopal Gurram on 7/13/24.
//

#if DEBUG
import UIKit
import EssentialFeed

class DebuggingSceneDelegate: SceneDelegate {
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL )
        }

        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    override func makeRemoteClient() -> HTTPClient {
        if let connectivity = UserDefaults.standard.string(forKey: "connectivity") {
            return DebuggingHttpClient(connectivity: connectivity)
        }

        return super.makeRemoteClient()
    }
}

private class DebuggingHttpClient: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }

    private let connectivity: String

    init(connectivity: String) {
        self.connectivity = connectivity
    }

    func get(
        from url: URL,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask {
        switch connectivity {
        case "online":
            completion(.success(makeSuccessfulURLResponse(for: url)))

        default:
            completion(.failure(NSError(domain: "offline", code: 0)))
        }


        return Task()
    }

    private func makeSuccessfulURLResponse(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!

        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()

        default:
            return makeFeedData()
        }
    }

    private func makeImageData() -> Data {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!.pngData()!
    }

    private func makeFeedData() -> Data {
        try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString, "image": "http://image.com"],
            ["id": UUID().uuidString, "image": "http://image.com"]
        ]])
    }
}
#endif