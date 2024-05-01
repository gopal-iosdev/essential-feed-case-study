//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 4/25/24.
//

import XCTest
import EssentialFeed

final class FeedImagePresenterTests: XCTestCase {

    func test_init_doesNotSentMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()

        sut.didStartLoadingImageData(for: image)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }

    func test_didFinishLoadingImageData_displaysRetryOnFailedImageTransformation() {
        let (sut, view) = makeSUT(imageTransformer: fail)
        let image = uniqueImage()
        let data = Data()

        sut.didFinishLoadingImageData(with: data, for: image)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }

    func test_didFinishLoadingImageData_displaysImageOnSuccessfulTransformation() {
        let image = uniqueImage()
        let data = Data()
        let transformedData = AnyImage()
        let (sut, view) = makeSUT(imageTransformer: {_ in transformedData})

        sut.didFinishLoadingImageData(with: data, for: image)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertEqual(message?.image, transformedData)
    }

    func test_didFinishLoadingImageDataWithError_displaysRetry() {
        let image = uniqueImage()
        let (sut, view) = makeSUT()

        sut.didFinishLoadingImageData(with: NSError.anyError, for: image)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, false)
        XCTAssertEqual(message?.shouldRetry, true)
        XCTAssertNil(message?.image)
    }

    // MARK: - Helpers

    private func makeSUT(
        imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
        file: StaticString = #file,
        line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>,
        view: ViewSpy
    ) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, view)
    }

    private var fail: (Data) -> AnyImage? {
        { _ in nil }
    }

    private struct AnyImage: Equatable {}

    private class ViewSpy: FeedImageView {
        var messages = [FeedImageViewModel<AnyImage>]()

        func display(_ model: FeedImageViewModel<AnyImage>) {
            messages.append(model)
        }
    }
}
