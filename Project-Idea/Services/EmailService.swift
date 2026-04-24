//
//  EmailService.swift
//  
//
//  Created by Tom Brophy on 10/03/2026.
//  This is the service to implement emails.

import Foundation

struct EmailService {

    static let domains = ["temp-vault.com", "secure-mail.org", "privacy-shield.io", "ghost-inbox.net"]

    static func createRandomEmail() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz1234567890"
        let randomString = String((0..<10).map{ _ in characters.randomElement() ?? "x"
        })

        let randomDomain = domains.randomElement() ?? "temp-vault.com"

        return "\(randomString)@\(randomDomain)"
    }
}
