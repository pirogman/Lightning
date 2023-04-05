//
//  SensorEvent.swift
//  Lightning
//

import SwiftUI

struct SensorEvent: Codable {
    /// UUID of the sensor aka device (optional)
    let sensorId: UUID?
    
    /// UUID of the recorded event
    let eventId: UUID
    
    /// Timestamp of the event in UNIX time
    let timestamp: TimeInterval
    
    // Coordinates of the event
    let lat, lon: CGFloat
    
    var date: Date {
        Date(timeIntervalSince1970: timestamp)
    }
}
