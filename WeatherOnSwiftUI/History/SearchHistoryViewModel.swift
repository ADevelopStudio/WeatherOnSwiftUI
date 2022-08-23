//
//  SearchHistoryViewModel.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import Foundation

@MainActor
class SearchHistoryViewModel: ObservableObject {
    enum LoadingState {
        case normal
        case loading
        case failedToUpdate
    }
    
    @Published private(set) var loadingState = LoadingState.normal
    @Published private(set) var weatherData: WeatherData
    
    private let service = ServiceManager()
    var onForecastSelected: ((WeatherData)->())? = nil
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }
    
    func update() async {
        loadingState = .loading
        do {
            let result = try await service.loadData(apiPath: ApiPath.update(id: weatherData.id))
            weatherData = result
            loadingState = .normal
        } catch {
            loadingState = .failedToUpdate
        }
    }
}
