//
//  CalculatedEvent.swift
//  Lightning
//

import SwiftUI

struct CalculatedEvent: Identifiable {
    let sensorEvents: [SensorEvent]
    
    let lat, lon: CGFloat
    let timestamp: TimeInterval
    
    var id: String { "\(lat)_\(lon)" }
    var date: Date { Date(timeIntervalSince1970: timestamp) }
    
    init(_ events: [SensorEvent]) {
        let first = events.first!
        self.lat = first.lat
        self.lon = first.lon
        self.timestamp = first.timestamp
        self.sensorEvents = events
    }
}
