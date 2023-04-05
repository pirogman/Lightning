//
//  AnalyserView.swift
//  Lightning
//

import SwiftUI
import MapKit
import UniformTypeIdentifiers

struct AnalyserView: View {
    @StateObject var viewModel = AnalyserViewModel()
    
    @State var selectedEvent: CalculatedEvent?
    @State var region = MKCoordinateRegion()
    @State var userTracking = MapUserTrackingMode.follow
    @State var showFilePicker = false
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTracking, annotationItems: viewModel.events) { event in
                    MapAnnotation(
                        coordinate: event.coordinate,
                        anchorPoint: CGPoint(x: 0.5, y: 0.5)
                    ) {
                        CalculatedEventView(event, selectedEvent: $selectedEvent)
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Analyser")
        .navigationBarItems(
            trailing:
                Button {
                    showFilePicker = true
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .renderingMode(.template)
                        .resizable().scaledToFit()
                        .frame(width: 24, height: 24)
                }
        )
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [UTType.json],
            allowsMultipleSelection: false
        ) { result in
            viewModel.handleSelectingFile(result)
        }
    }
}
