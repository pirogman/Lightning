# Lightning

🥈 **Second place** in iOS Dev Challenge XIX on 29.10.2022

![2nd_place](https://user-images.githubusercontent.com/11997085/230093977-933fb758-025e-495d-804b-76f7a779516c.png)

## Task Description

You are developing an iPhone/iPad (Swift) application that is going to help determine the location of the lighting. There has been quite a lot of lightning in Ukraine lately and sometimes it is necessary to know where they are happening. This application should operate in two models:

- **Sensor** (Peer) - A statically located device with a precise location. The purpose of the sensor is to detect and track loud events.
- **Analyzer** (Host) - The app receives logs and visualizes calculated boom points.

## Screenshots

<img src="https://user-images.githubusercontent.com/11997085/230090633-b86f86e9-d57b-4633-b381-a89848cf54fb.PNG" width=200> <img src="https://user-images.githubusercontent.com/11997085/230090703-dcba2c41-ce6a-444e-96f7-6a511f4cc1dc.PNG" width=200> <img src="https://user-images.githubusercontent.com/11997085/230090744-e1c74da0-a024-403f-b53f-3d907f2d5d52.PNG" width=200>

## Technologies

- UI build with SwiftUI
- MVVM Architecture
- Sensor: CoreLocation and AVFoundation to record loud sounds at the device location
- Analyser: MapKit to show events on the map
