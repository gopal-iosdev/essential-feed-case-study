//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Gopal Gurram on 7/30/23.
//

import XCTest
import EssentialFeed

final class URLSessionHTTPClientTests: XCTestCase {

    override func tearDown() {
        super.tearDown()

        URLProtocolStub.removeStub()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = URL.anyURL
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(from: url) { _ in }

        wait(for: [exp], timeout: 1.0)
    }

    func test_cancelGetFromURLTask_cancelsURLRequest() {
        var task: HTTPClientTask?
        URLProtocolStub.onStartLoading { task?.cancel() }
        let receivedError = resultErrorFor(taskHandler: { task = $0 }) as NSError?

        XCTAssertEqual(receivedError?.code, URLError.cancelled.rawValue)
    }

    func test_getFromURL_failsOnRequestError() {
        let requestError = NSError.anyError

        let receivedError = resultErrorFor((data: nil, response: nil, error: requestError)) as NSError?

        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }

    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        let nonHTTPURLResponse = URLResponse.nonHTTPURLResponse
        let anyHTTPURLResponse = HTTPURLResponse.anyHTTPURLResponse
        let anyData = Data.anyData
        let anyNSError = NSError.anyError

        XCTAssertNotNil(resultErrorFor((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData, response: nil, error: anyNSError)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse, error: anyNSError)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: anyHTTPURLResponse, error: anyNSError)))
        XCTAssertNotNil(resultErrorFor((data: anyData, response: nonHTTPURLResponse, error: anyNSError)))
        XCTAssertNotNil(resultErrorFor((data: anyData, response: anyHTTPURLResponse, error: anyNSError)))
        XCTAssertNotNil(resultErrorFor((data: anyData, response: nonHTTPURLResponse, error: nil)))
    }

    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = Data.anyData
        let response = HTTPURLResponse.anyHTTPURLResponse

        let receivedValues = resultValuesFor((data: data, response: response, error: nil))

        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response?.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response?.statusCode)
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = HTTPURLResponse.anyHTTPURLResponse

        let receivedValues = resultValuesFor((data: nil, response: response, error: nil))

        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response?.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response?.statusCode)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)

        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(values, file: file, line: line)

        switch result {
        case let .success((data, response)):
            return (data, response)
        default:
            XCTFail("Expected success, got \(result) instead.", file: file, line: line)
            return nil
        }
    }

    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = resultFor(values, taskHandler: taskHandler, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead.", file: file, line: line)
            return nil
        }
    }

    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, taskHandler: (HTTPClientTask) -> Void = { _ in },  file: StaticString = #file, line: UInt = #line) -> HTTPClient.Result {
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }

        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        var receivedResult: HTTPClient.Result!
        taskHandler(sut.get(from: URL.anyURL) { result in
            receivedResult = result

            exp.fulfill()
        })

        wait(for: [exp], timeout: 1.0)

        return receivedResult
    }
}

private extension URLResponse {
    static let nonHTTPURLResponse = URLResponse(url: URL.anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

private extension HTTPURLResponse {
    static let anyHTTPURLResponse = HTTPURLResponse(url: URL.anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)

}
