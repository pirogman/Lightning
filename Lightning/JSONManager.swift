//
//  JSONManager.swift
//  Lightning
//

import SwiftUI

class JSONManager {
    static let shared = JSONManager()
    private init() { }
    
    func saveToFile(_ events: [SensorEvent]) -> URL? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(events)
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("events.json")
            try data.write(to: url, options: .atomic)
            return url
        } catch let error {
            print("Encoding error: \(error)")
            return nil
        }
    }
    
    func loadTestData() -> [SensorEvent] {
        let data = JSONManager.loadJSON(fileName: "test_data")!
        let results: [SensorEvent] = JSONManager.decodeJSON(from: data)!
        return results.sorted { $0.timestamp < $1.timestamp }
    }
    
    func load(from url: URL) -> [SensorEvent] {
        if let data = JSONManager.loadJSON(fileURL: url),
           let results: [SensorEvent] = JSONManager.decodeJSON(from: data)
        {
            return results.sorted { $0.timestamp < $1.timestamp }
        }
        return []
    }
    
    // MARK: - Helpers
    
    static private func decodeJSON<T: Decodable>(from data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let jsonObject = try decoder.decode(T.self, from: data)
            return jsonObject
        } catch let error {
            print("Decoding error: \(error)")
            return nil
        }
    }
    
    static private func loadJSON(fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("No such file...")
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return jsonData
        } catch let error {
            print("Loading error: \(error)")
            return nil
        }
    }
    
    static private func loadJSON(fileURL: URL) -> Data? {
        guard fileURL.isFileURL else {
            print("No a file url...")
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            return jsonData
        } catch let error {
            print("Loading error: \(error)")
            return nil
        }
    }
}
