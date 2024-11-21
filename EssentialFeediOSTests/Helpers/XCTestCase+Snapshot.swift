//
//  XCTestCase+Snapshot.swift
//  EssentialFeediOSTests
//
//  Created by Gopal Rao Gurram on 11/21/24.
//

import XCTest

extension XCTest {
    func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotData = makeSnapShotData(for: snapshot,file: file, line: line)
        let snapshotURL = makeSnapShotURL(named: name, file: file)

        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }

        if snapshotData != storedSnapshotData {
            let temporarySnapShotURL = URL(filePath: NSTemporaryDirectory())
                .appendingPathComponent(snapshotURL.lastPathComponent)

            try? snapshotData?.write(to: temporarySnapShotURL)

            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapShotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }

    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotData = makeSnapShotData(for: snapshot,file: file, line: line)
        let snapshotURL = makeSnapShotURL(named: name, file: file)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

    func makeSnapShotURL(named name: String, file: StaticString) -> URL {
        URL(filePath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }

    func makeSnapShotData(for snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }

        return data
    }

}
