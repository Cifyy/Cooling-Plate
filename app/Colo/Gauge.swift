//
//  gauge.swift
//  Colo
//
//  Created by Jakub Majka on 18/4/25.
//

import SwiftUI

struct Gauge: View {
    
    @Binding var value: CGFloat
    let config: Config
    var angleValue: CGFloat{ setAngle(value: value, config: config)}
    
    var body: some View {
        VStack{
            ZStack {
                //Background
//                Circle()
//                    .trim(from: 0.0, to: 0.75)
//                    .stroke(Color.black.opacity(0.1), style: StrokeStyle(lineWidth: 45, lineCap: .round))
//                    .rotationEffect(.degrees(135))
//                    .frame(width: config.radius * 2, height: config.radius * 2)
                
                //Background fill
                Circle()
                    .trim(from: 0 , to: 0.75)
                    .stroke(
                        config.gradient,
                        style: StrokeStyle(lineWidth: config.knobRadius * 2, lineCap: .round)
                    )
                    .frame(width: config.radius * 2, height: config.radius * 2)
                    .rotationEffect(.degrees(-225))
                
                //Shadow
                Circle()
                    .fill(Color.init(red: 34/255, green: 30/255, blue: 47/255))
                    .frame(width: config.knobRadius * 3.2, height: config.knobRadius * 3.2)
                    .padding(10)
                    .offset(y: -config.radius)
                    .rotationEffect(Angle.degrees(Double(angleValue) - 135))
                
                //Current
                Circle()
                    .fill(Color.white)
                    .frame(width: config.knobRadius * 2.5, height: config.knobRadius * 2.5)
                    .padding(10)
                    .offset(y: -config.radius)
                    .rotationEffect(Angle.degrees(Double(angleValue) - 135))
                Text("\(String.init(format: "%.0f", value))\(config.unit)")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
            }
            Text(config.name)
                .font(.system(size: 10))
                .foregroundColor(.white)
                .offset(y:-10)
                .fontWeight(.semibold)
        }
    }
}


//#Preview {
//    gauge()
//}
