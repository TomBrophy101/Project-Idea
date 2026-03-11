//
//  Item.swift
//  Project-Idea
//
//  Created by Tom Brophy on 10/03/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id: UUID
    var title: String
    var serviceType: String
    var secureData: String
    var timestamp: Date
    
    init(title: String, serviceType: String, secureData: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.serviceType = serviceType
        self.secureData = secureData
        self.timestamp = timestamp
    }
}
