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

    func testSaveKeyWithoutThrowingError() throws {
        try! service.save(key: testKey, value: "Secret123.")
        XCTAssert(true)
    }

    func testSaveAndLoadKeySucccessfully() throws {
        try! service.save(key: testKey, value: "Secret123.")
        let data = try! service.load(key: testKey)
        XCTAssertNotNil(data)
    }
}
