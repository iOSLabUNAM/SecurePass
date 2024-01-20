//
//  KeychainService.swift
//  SecurePass
//
//  Created by Luis Ezcurdia on 19/01/24.
//

import Foundation

struct KeychainService {
  let defaultService = "com.3zcurdia.SecurePass"
  let queue = DispatchQueue(label: "com.3zcurdia.SecurePass.keychain", qos: .background, attributes: .concurrent)

  enum KeychainError: Error {
      case noPassword
      case unhandledError(status: OSStatus)
  }

  func save(key: String, value: String, completion: @escaping (Error?) -> Void) {
    queue.async {
      do {
        try self.save(key: key, value: value)
        DispatchQueue.main.async { completion(nil) }
      } catch {
        DispatchQueue.main.async { completion(error) }
      }
    }
  }

  func save(key: String, value: String) throws {
    guard let data = value.data(using: .utf8) else { return }
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: defaultService,
                                kSecAttrAccount as String: key,
                                kSecValueData as String: data]
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  func load(key: String) throws -> String? {
      let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                  kSecAttrService as String: defaultService,
                                  kSecAttrAccount as String: key,
                                  kSecMatchLimit as String: kSecMatchLimitOne,
                                  kSecReturnData as String: true]
      var dataTypeRef: AnyObject?
      let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
      guard status != errSecItemNotFound else { throw KeychainError.noPassword }
      guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
      if let data = dataTypeRef as? Data {
          return String(data: data, encoding: .utf8)
      } else {
          return nil
      }
  }

  func delete(key: String) {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: key]
    SecItemDelete(query as CFDictionary)
  }
}
