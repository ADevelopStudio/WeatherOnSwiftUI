//
//  ServiceManager.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 22/8/2022.
//

import Foundation
import Combine

enum ApiPath {
    case search(String)
    case update(id: Int)
}

extension ApiPath {
    private static let apiKey = "95d190a434083879a6398aafd54d9e73"
    
    private var queryItem: URLQueryItem {
        switch self {
        case .search(let searchString):
            return URLQueryItem(name: "q", value: [searchString, "au"].joined(separator: ","))
        case .update(let id):
            return URLQueryItem(name: "id", value: String(describing: id))
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        let queryAppId = URLQueryItem(name: "appid", value: ApiPath.apiKey)
        let queryMetric = URLQueryItem(name: "units", value: "metric")
        components.queryItems = [self.queryItem, queryAppId, queryMetric]
        return components.url
    }
}


struct ServiceManager {
    enum ServiceError: Error, LocalizedError {
        case generalFailure
        case invalidStatus
        
        public var errorDescription: String? {
            switch self {
            case .invalidStatus:
                return "Nothing found"
            case .generalFailure:
                return "Something went wrong"
            }
        }
    }
    
    func loadData(apiPath: ApiPath) async throws -> WeatherData {
        guard let url = apiPath.url else { throw ServiceError.generalFailure }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw ServiceError.invalidStatus
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try decoder.decode(WeatherData.self, from: data)
        return decodedData
    }
}
