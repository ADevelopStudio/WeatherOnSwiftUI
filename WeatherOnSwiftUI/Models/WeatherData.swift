//
//  WeatherData.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 22/8/2022.
//

import Foundation

fileprivate struct Location: Codable {
    var longitude: Double
    var latitude : Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

fileprivate struct WeatheDetails: Codable {
    var description: String
    var icon: String
}

fileprivate struct WeatherMain: Codable {
    var temp: Double
    var feelsLike: Double
    var tempMin: Double
    var tempMax: Double
    var pressure: Double
    var humidity: Double
}


struct WeatherData: Codable {
    static let example = WeatherData(id: 2147714, name: "Sydney", coord: Location(longitude: 0, latitude: 0), weather: [WeatheDetails(description: "moderate rain", icon: "10n")], main: WeatherMain(temp: 22, feelsLike: 20, tempMin: 18, tempMax: 25, pressure: 10, humidity: 65))
    
    var id: Int
    var name: String
    private var coord: Location
    private var weather: [WeatheDetails]
    private var main: WeatherMain
}

extension WeatherData: Identifiable, Hashable {
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WeatherData {
    func getImageUrl(isLarge: Bool = false) -> URL? {
        guard let icon = self.weather.first?.icon, !icon.isEmpty,
              let url = URL(string: "https://openweathermap.org/img/wn/\(icon)\(isLarge ? "@2x" : "").png") else {
            return nil
        }
        return url
    }
    
    func getData(type: TypeOfWeatherData) -> String {
        switch type {
        case .humidity:
            return "\(Int(self.main.humidity))%"
        case .weatherDescr:
            return self.weather.map({$0.description}).joined(separator: ", ")
        case .temperature:
            return self.main.temp.toTemperature
        case .temperatureFillsLike:
            return self.main.feelsLike.toTemperature
        case .temperatureMax:
            return self.main.tempMax.toTemperature
        case .temperatureMin:
            return self.main.tempMin.toTemperature
        case .pressure:
            return self.main.pressure.toPressure
        }
    }
}

fileprivate extension Double {
    var toTemperature: String {
        let tempLocalisedStr = MeasurementFormatter().string(from: Measurement(value: Double(Int(self)), unit: UnitTemperature.celsius))
        if !tempLocalisedStr.contains("C") || self < 0 { return tempLocalisedStr }
        return ["+", tempLocalisedStr].joined()
    }
    var toPressure: String {
        MeasurementFormatter()
            .string(from: Measurement(value: self, unit: UnitPressure.hectopascals))
    }
}
