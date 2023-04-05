//
//  SensorViewModel.swift
//  Lightning
//

import SwiftUI
import AVFoundation
import CoreLocation

class SensorViewModel: NSObject, ObservableObject {
    @Published private(set) var isActive = false
    @Published var recordedEvents = [SensorEvent]()
    
    private let deviceId = UIDevice.current.identifierForVendor
    
    private let locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D()
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    deinit {
        deactivate()
    }
    
    // MARK: - Recording Properties
    
    private var recorder: AVAudioRecorder!
    private let recordURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]).appendingPathComponent("record.caf")
    private let recordSettings: [String: Any] = [
        AVFormatIDKey: kAudioFormatAppleIMA4,
        AVSampleRateKey: 44100.0,
        AVNumberOfChannelsKey: 2,
        AVEncoderBitRateKey: 12800,
        AVLinearPCMBitDepthKey: 16,
        AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
    ]
    private let updateInterval: TimeInterval = 0.1
    private var updateTimer: Timer?
    
    // MARK: - Actions
    
    func activate() {
        guard !isActive else { return }
        isActive = true
        
        do {
            // Track user location
            locationManager.startUpdatingLocation()
            
            // Activate audio session for recording
            try AVAudioSession.sharedInstance().setCategory(.record)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Create recorder if needed
            if recorder == nil {
                recorder = try AVAudioRecorder(url: recordURL, settings: recordSettings)
                recorder.prepareToRecord()
                recorder.isMeteringEnabled = true
            }
            recorder.record()
            
            // Start update timer
            updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] timer in
                self?.handleUpdateTimer()
            }
            updateTimer!.tolerance = updateInterval / 10
        } catch let error {
            print("Activate error: \(error)")
            deactivate()
        }
    }
    
    func deactivate() {
        guard isActive else { return }
        isActive = false
        
        // Stop update timer
        updateTimer?.invalidate()
        
        // Stop recording
        recorder?.stop()
        
        // Deactivate audio session
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        
        // Remove recorded sound
        try? FileManager.default.removeItem(at: recordURL)
        
        // Stop traking location
        locationManager.stopUpdatingLocation()
    }
    
    func save() {
        guard !recordedEvents.isEmpty else { return }
    }
    
    // MARK: - Handle Loud Sound
    
    private let peakPowerLimit: Float = -1
    private let averagePowerLimit: Float = -10
    
    struct LoudSound {
        let peak: Float
        let average: Float
        let interval: TimeInterval
        let timestamp: TimeInterval
        let coordinates: CLLocationCoordinate2D
    }
    
    private var loud = [LoudSound]()
        
    private func handleUpdateTimer() {
        recorder.updateMeters()
        
        let average = recorder.averagePower(forChannel: 0)
        let peak = recorder.peakPower(forChannel: 0)
        if peak > peakPowerLimit && average > averagePowerLimit {
            // Recorded LOUD enough sound...
            // Store this bit to track overall duration of a loud sound
            //print(" ! recorded loud sound - peak: \(peak) | average: \(average)")
            let sound = LoudSound(peak: peak, average: average, interval: updateInterval, timestamp: Date().timeIntervalSince1970, coordinates: userLocation)
            loud.append(sound)
        } else {
            // Recorded NOT loud enough sound...
            // Handle tracked loud sounds if any
            if !loud.isEmpty {
                //print(" ! handled \(loud.count) loud sounds")
                let sound = loud.first!
                let possibleEvent = SensorEvent(sensorId: deviceId, eventId: UUID(), timestamp: sound.timestamp, lat: sound.coordinates.latitude, lon: sound.coordinates.longitude)
                recordedEvents.append(possibleEvent)
                loud.removeAll()
            }
        }
    }
}

extension SensorViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = manager.location!.coordinate
        //print(" ! user coordinates changed = lat: \(userLocation.latitude) | lon: \(userLocation.longitude)")
    }
}
