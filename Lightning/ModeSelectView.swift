//
//  ModeSelectView.swift
//  Lightning
//

import SwiftUI

struct ModeSelectView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ZStack {
                    Image(systemName: "bolt.fill")
                        .renderingMode(.template)
                        .resizable().scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    Image(systemName: "bolt.fill")
                        .renderingMode(.template)
                        .resizable().scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.yellow)
                        .offset(x: 12, y: -6)
                }
                Spacer()
                VStack {
                    NavigationLink {
                        SensorView()
                    } label: {
                        menuButtonView(title: "Sensor Mode")
                    }
                    menuHintView(text: "Use your device as a sensor for loud sounds, record and save them for later use in analyser mode")
                }
                Spacer()
                VStack {
                    NavigationLink {
                        AnalyserView()
                    } label: {
                        menuButtonView(title: "Analyser Mode")
                    }
                    menuHintView(text: "Use your device as an analyser of loud sounds, importing previously record events from sensor mode")
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 36)
        }
    }
    
    private func menuButtonView(title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .strokeBorder()
            )
    }
    
    private func menuHintView(text: String) -> some View {
        Text(text)
            .font(.footnote)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
    }
}
