//
//  KeychainServiceTest.swift
//  SecurePassTests
//
//  Created by Luis Ezcurdia on 19/01/24.
//

import XCTest
@testable import SecurePass

final class KeychainServiceTest: XCTestCase {
    let service = KeychainService()
    let testKey = UUID().uuidString

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {
        service.delete(key: testKey)
    }

    func testQueuedSaveWithoutThrowingError() throws {
        let expectation = XCTestExpectation(description: "Save in keychain")
        service.save(key: testKey, value: "Secret") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testSaveKeyWithoutThrowingError() throws {
        try! service.save(key: testKey, value: "Secret1.")
        XCTAssert(true)
    }

    func testSaveAndLoadKeySuccessfully() throws {
        try! service.save(key: testKey, value: "Secret12.")
        let data = try! service.load(key: testKey)
        XCTAssertNotNil(data)
    }

    func testDeleteSuccessfully() throws {
        try! service.save(key: testKey, value: "Secret123.")
        service.delete(key: testKey)
        let data = try? service.load(key: testKey)
        XCTAssertNil(data)
    }
}
