//
//  TypeOfWeatherData.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 22/8/2022.
//

import Foundation


enum TypeOfWeatherData {
    static let unitsForDetailsView = [TypeOfWeatherData.temperature, .temperatureFillsLike, .temperatureMin, .temperatureMax, .pressure, .humidity]
    case weatherDescr
    case temperature
    case temperatureFillsLike
    case temperatureMax
    case temperatureMin
    case pressure
    case humidity
}

extension TypeOfWeatherData {
    var title: String {
        switch self {
        case .weatherDescr:
            return ""
        case .temperature:
            return "Temperature"
        case .temperatureFillsLike:
            return "Fills Like"
        case .temperatureMax:
            return "Temperature Max"
        case .temperatureMin:
            return "Temperature Min"
        case .pressure:
            return "Pressure"
        case .humidity:
            return "Humidity"
        }
    }
}

extension TypeOfWeatherData: Identifiable {
    var id: TypeOfWeatherData { self }
}
