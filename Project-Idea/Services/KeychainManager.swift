//
//  KeychainManager.swift
//  
//
//  Created by Tom Brophy on 10/03/2026.
//
import Foundation
import Security

struct KeychainManager {
    static func save(key: String, data: String) {
        let dataToSave = Data(data.utf8)

        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: dataToSave
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("Error saving to Keychain: \(status)")
        }
    }

    static func load(key: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }

}
