//
//  SensorView.swift
//  Lightning
//

import SwiftUI

struct SensorView: View {
    @StateObject var viewModel = SensorViewModel()
    
    var buttonTitle: String { viewModel.isActive ? "Stop" : "Activate" }
    var buttonFont: Font { viewModel.isActive ? .body : .largeTitle }
    var buttonWidth: CGFloat { viewModel.isActive ? 80 : 180 }
    var buttonHeight: CGFloat { viewModel.isActive ? 80 : 180 }
    var buttonColor: Color { viewModel.isActive ? Color.red : Color.green }
        
    var body: some View {
        VStack {
            VStack {
                NavigationLink {
                    SensorEventListView(events: $viewModel.recordedEvents)
                } label: {
                    Text(viewModel.recordedEvents.isEmpty ? "No events" : "Check \(viewModel.recordedEvents.count) event(s)")
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .strokeBorder(Color.accentColor)
                        )
                }
                .disabled(viewModel.recordedEvents.isEmpty)
                if !viewModel.recordedEvents.isEmpty {
                    Text("Unsaved events will be lost!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            Spacer()
            if viewModel.isActive {
                VStack {
                    ProgressView().progressViewStyle(.circular)
                        .padding(.all, 8)
                    Text("Listening for events...")
                }
                .foregroundColor(.gray)
                Spacer()
            }
            Button {
                viewModel.isActive ? viewModel.deactivate() : viewModel.activate()
            } label: {
                Text(buttonTitle)
                    .font(buttonFont)
                    .foregroundColor(.white)
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(buttonColor)
                    .clipShape(Circle())
            }
            if !viewModel.isActive {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Sensor")
        .navigationBarItems(
            trailing:
                Button {
                    viewModel.recordedEvents.removeAll()
                } label: {
                    Image(systemName: "trash")
                        .renderingMode(.template)
                        .resizable().scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .opacity(viewModel.recordedEvents.isEmpty ? 0 : 1)
        )
    }
}
