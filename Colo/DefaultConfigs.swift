//
//  DefaultConfigs.swift
//  Colo
//
//  Created by Jakub Majka on 19/4/25.
//
import SwiftUI

let coolantDefaultConfig = Config(minimumValue: 20.0,
                           maximumValue: 80.0,
//                           totalValue: 80.0,
                           knobRadius: 5.0,
                           radius: 40.0,
                           name: "Coolant",
                           unit: "º",
                           gradient:
                            AngularGradient(
                                gradient: Gradient(stops: [
//                                    .init(color: .blue, location: 0.0),
                                    .init(color: .green, location: 0.40),
                                    .init(color: .orange, location: 0.75),
                                    .init(color: .red, location: 0.9)
                                ]),
                                center: .center,
                                //                            startAngle: .degrees((temperatureValue / config.totalValue) * 0.75 * 270),
                                //                            endAngle: .degrees((currentTemperature / config.totalValue) * 0.75 * 270)
                                startAngle: .degrees(0),
                                endAngle: .degrees(270)
                            )
)

let humidityDefaultConfig = Config(minimumValue: 0.0,
                            maximumValue: 100.0,
//                            totalValue: 100.0,
                            knobRadius: 5.0,
                            radius: 40.0,
                            name: "Humidity",
                            unit: "%",
                            gradient:                         AngularGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .white, location: 0.00),
                                    .init(color: .blue, location: 0.40)
                                ]),
                                center: .center,
                                //                            startAngle: .degrees((temperatureValue / config.totalValue) * 0.75 * 270),
                                //                            endAngle: .degrees((currentTemperature / config.totalValue) * 0.75 * 270)
                                startAngle: .degrees(0),
                                endAngle: .degrees(270)
                            ))
let ambientDefaultTemperatureConfig = Config(minimumValue: 10.0,
                                      maximumValue: 40.0,
//                                      totalValue: 40.0,
                                      knobRadius: 5.0,
                                      radius: 40.0,
                                      name: "Ambient",
                                      unit: "º",
                                      gradient:                        AngularGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: .blue, location: 0.30),
                                            .init(color: .white, location: 0.50),
                                            .init(color: .orange, location: 0.80),
                                        ]),
                                        center: .center,
                                        //                            startAngle: .degrees((temperatureValue / config.totalValue) * 0.75 * 270),
                                        //                            endAngle: .degrees((currentTemperature / config.totalValue) * 0.75 * 270)
                                        startAngle: .degrees(0),
                                        endAngle: .degrees(270)
                                      ))
