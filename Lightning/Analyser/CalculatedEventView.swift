//
//  CalculatedEventView.swift
//  Lightning
//

import SwiftUI

struct CalculatedEventView: View {
    let event: CalculatedEvent
    
    @Binding var selectedEvent: CalculatedEvent?
    
    var isSelected: Bool { event.id == selectedEvent?.id }
    
    init(_ event: CalculatedEvent, selectedEvent: Binding<CalculatedEvent?>) {
        self.event = event
        self._selectedEvent = selectedEvent
    }
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "bolt.fill")
                .renderingMode(.template)
                .resizable().scaledToFit()
                .foregroundColor(.yellow)
                .frame(width: 48, height: 48)
                .padding(.all, 6)
                .background(Color.white)
                .clipShape(Circle())
                .scaleEffect(isSelected ? 1 : 0.5)
            if isSelected {
                VStack(spacing: 0) {
                    Text("\(timeFormatter.string(from: event.date))")
                    Text("\(dayFormatter.string(from: event.date))")
                    Text("\(event.sensorEvents.count) event(s)")
                }
                .frame(minWidth: 140)
                .font(.footnote)
                .lineLimit(1)
                .foregroundColor(.black)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                )
            }
        }
        .onTapGesture {
            withAnimation {
                if isSelected { selectedEvent = nil }
                else { selectedEvent = event }
            }
        }
    }
}
