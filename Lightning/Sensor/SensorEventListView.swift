//
//  SensorEventListView.swift
//  Lightning
//

import SwiftUI

struct SensorEventListView: View {
    @Binding var events: [SensorEvent]
    
    @State var showShare = false
    
    private var shareActivities: [AnyObject] {
        var activities = [AnyObject]()
        if let url = JSONManager.shared.saveToFile(events) {
            activities.append(url as AnyObject)
        }
        return activities
    }
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        List(events, id: \.eventId) { event in
            VStack(alignment: .leading, spacing: 8) {
                Text("Event: \(event.eventId)")
                if let sensorId = event.sensorId {
                    Text("From sensor: \(sensorId)")
                } else {
                    Text("From unknown sensor")
                }
                HStack {
                    Text("lat: \(event.lat)")
                    Spacer()
                    Text("lon: \(event.lon)")
                }
                Text("\(formatter.string(from: event.date))")
            }
            .font(.footnote)
            .lineLimit(1)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Events")
        .navigationBarItems(
            trailing:
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .renderingMode(.template)
                        .resizable().scaledToFit()
                        .frame(width: 24, height: 24)
                }
        )
        .sheet(isPresented: $showShare) {
            ActivityViewController(activityItems: shareActivities)
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {
        //
    }
}
