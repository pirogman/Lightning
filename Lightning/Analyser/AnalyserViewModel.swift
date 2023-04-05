//
//  AnalyserViewModel.swift
//  Lightning
//

import SwiftUI
import CoreLocation
import MapKit

class AnalyserViewModel: ObservableObject {
    @Published var events = [CalculatedEvent]()
    
    // TODO: What values to use?
    let closeDistance: CLLocationDistance = 10_000 // 10 km
    let closeInterval: TimeInterval = 60 // 1 minute
    
    init() {
        
    }
    
    func handleSensorEvents(_ array: [SensorEvent]) {
        events.removeAll()
        for se in array {
            if let index = events.firstIndex(where: { ce in
                ce.coordinate.distance(from: se.coordinate) < closeDistance
                && ce.timestamp - se.timestamp < closeInterval
            }) {
                let new = events[index].sensorEvents + [se]
                events[index] = CalculatedEvent(new)
            } else {
                events.append(CalculatedEvent([se]))
            }
        }
    }
    
    private func testWithDummyData() {
        handleSensorEvents(JSONManager.shared.loadTestData())
    }
    
    // MARK: - Import from file
    
    func handleSelectingFile(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                // Remember this access start/stop
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    let result = JSONManager.shared.load(from: url)
                    handleSensorEvents(result)
                }
            }
        case .failure(_):
            break
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination = CLLocation(latitude: from.latitude, longitude: from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}

extension SensorEvent {
    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lon) }
}

extension CalculatedEvent {
    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: lat, longitude: lon) }
}
