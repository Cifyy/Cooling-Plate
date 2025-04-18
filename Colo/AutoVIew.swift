//
//  AutoVIew.swift
//  Colo
//
//  Created by Jakub Majka on 19/4/25.
//

import SwiftUI

func distance(_ p1: CGPoint,_ p2: CGPoint) -> Double {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y))
}

struct AutoView: View {
    
    @Binding var selectedMode: OperationMode
    @Binding var temperatureValue: CGFloat
    var angleValue: CGFloat{ setAngle(value: temperatureValue, config: config)}
    
    @State private var isDraggingInside = true

    @State var currentTemperature: CGFloat = 25.0
    
    var displayTemperature: CGFloat{
        if selectedMode == .Auto{
            return temperatureValue
        }
        else{
            return currentTemperature
        }
    }
    
    let config = Config(minimumValue: 0.0,
                        maximumValue: 30.0,
//                        totalValue: 30.0,
                        knobRadius: 15.0,
                        radius: 125.0,
                        name: "DWA",
                        unit: "daw",
                        gradient:                         AngularGradient(
                            gradient: Gradient(stops: [
                                .init(color: .purple, location: 0.0),
                                .init(color: .blue, location: 0.40),
                                .init(color: .white, location: 0.70),
                                .init(color: .orange, location: 0.80),
                                .init(color: .red, location: 0.95)
                            ]),
                            center: .center,
                            //                            startAngle: .degrees((temperatureValue / config.totalValue) * 0.75 * 270),
                            //                            endAngle: .degrees((currentTemperature / config.totalValue) * 0.75 * 270)
                            startAngle: .degrees(0),
                            endAngle: .degrees(270)
                        )
    )
    
    var body: some View {
        
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.75)
                .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 40, lineCap: .round))
                .rotationEffect(.degrees(135))
                .frame(width: config.radius * 2, height: config.radius * 2)
                
            Circle()
                .trim(from: 0.0, to: 0.75)
            
                .stroke(Color.gray,
                        style: StrokeStyle(lineWidth: 3, lineCap: .butt, dash: [3, 23.18]))
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(135))
            
            //Difference
            Circle()
                .trim(from: temperatureValue/config.maximumValue * 3/4, to: currentTemperature/config.maximumValue * 3/4)
                .stroke(
                    config.gradient,
                    style: StrokeStyle(lineWidth: config.knobRadius * 1.4, lineCap: .round)
                )
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(-225))
                .opacity(selectedMode == .Auto ? 1 : 0)
            
            //Manual
            Circle()
                .trim(from: 0, to: currentTemperature/config.maximumValue * 3/4)
                .stroke(
                    config.gradient,
                    style: StrokeStyle(lineWidth: config.knobRadius * 1.4, lineCap: .round)
                )
                .frame(width: config.radius * 2, height: config.radius * 2)
                .rotationEffect(.degrees(-225))
                .opacity(selectedMode == .Manual ? 1 : 0)
            
            //Current temp shadow dot
            Circle()
                .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
                .frame(width: config.knobRadius * 1.7, height: config.knobRadius * 1.7)
                .padding(10)
                .offset(y: -config.radius)
            //                .rotationEffect(Angle.degrees(Double(angleValue) - 60))
                .rotationEffect(Angle.degrees(currentTemperature/config.maximumValue * 270.0 - 135))
            
            //Current temp dow
            Circle()
                .fill(Color.white)
                .frame(width: config.knobRadius * 1.4, height: config.knobRadius * 1.4)
                .padding(10)
                .offset(y: -config.radius)
            //                .rotationEffect(Angle.degrees(Double(angleValue) - 60))
                .rotationEffect(Angle.degrees(currentTemperature/config.maximumValue * 270.0 - 135))
            
            
            Circle()
                .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
                .frame(width: config.knobRadius * 2.5, height: config.knobRadius * 2.5)
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue) - 135))
                .opacity(selectedMode == .Auto ? 1 : 0)
            
            Circle()
                .fill(Color.white)
                .frame(width: config.knobRadius * 2, height: config.knobRadius * 2)
                .padding(10)
                .offset(y: -config.radius)
                .rotationEffect(Angle.degrees(Double(angleValue) - 135))
                .opacity(selectedMode == .Auto ? 1 : 0)
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged { value in
                            let dist = distance(CGPoint(x: 25, y: 25), value.location)
                            if dist >= 70 && dist <= 170 && isDraggingInside == true{
                                change(location: value.location)
                            }else{
                                isDraggingInside = false
                            }
                        }
                        .onEnded { _ in
                            isDraggingInside = true
                        }
                )
            
            VStack{
                Text("Current \(String.init(format: "%.0f", currentTemperature))º")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .opacity(selectedMode == .Auto ? 1 : 0)
                
                Text("\(String.init(format: "%.0f", displayTemperature))º")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            
        }.padding(.top, 20).coordinateSpace(name: "knob")
    }
    
    private func change(location: CGPoint) {
        //        currentPosition = location
        let vector = CGVector(dx: location.x, dy: location.y)
        
        var angle = atan2(vector.dy - (config.knobRadius + 10), vector.dx - (config.knobRadius + 10)) + .pi/2.0
        angle += (135/180) * .pi
        angle = angle.truncatingRemainder(dividingBy: 2.0 * .pi)
        
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        
        let value = fixedAngle / (2.0 * .pi) * config.maximumValue * 4/3
        
        if (fixedAngle * 180 / .pi) <= 270 && value <= currentTemperature && value < config.maximumValue {
            temperatureValue = value
//            angleValue = (fixedAngle * 180 / .pi)
        }
    }
}

