//
//  EmailService.swift
//  
//
//  Created by Tom Brophy on 10/03/2026.
//
import Foundation

struct EmailService {

    static let domains = ["temp-vault.com", "secure-mail.org", "privacy-shield.io", "ghost-inbox.net"]

    static func createRandomEmail() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz1234567890"
        let randomString = String((0..<10).map{ _ in characters.randomElement() ?? "x"
        })

        return "\(randomString)@temp-vault.com"
    }
}
