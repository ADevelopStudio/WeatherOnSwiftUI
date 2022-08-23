//
//  Repository.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import Foundation

actor HistorySearchStorage: ObservableObject {
    
    private let userDefaultsKey: String
    private(set) var searchHistory: Array<WeatherData>
    
    init(userDefaultsKey: String = "HistorySearchStorage") {
        self.userDefaultsKey = userDefaultsKey
        if let saved =  UserDefaults.standard.object(forKey: userDefaultsKey) as? Data,
           let loadedDetails = try? JSONDecoder().decode([WeatherData].self, from: saved) {
            searchHistory = loadedDetails
        } else {
            searchHistory = []
        }
    }
    
    func save(data: WeatherData) {
        if let index = searchHistory.firstIndex(where: {$0.id == data.id}) {
            _ = searchHistory.remove(at: index)
        }
        searchHistory.insert(data, at: 0)
        self.saveResult()
    }
    
    func remove(at offsets: IndexSet) {
        searchHistory.remove(atOffsets: offsets)
        saveResult()
    }
    
    nonisolated func getSearchHistory() -> [WeatherData] {
        if let saved =  UserDefaults.standard.object(forKey: userDefaultsKey) as? Data,
           let loadedDetails = try? JSONDecoder().decode([WeatherData].self, from: saved) {
            return loadedDetails
        }
        return []
    }
    
    private func saveResult() {
        do {
            let encoded = try JSONEncoder().encode(searchHistory)
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        } catch {
            print("Saving data error: ", error)
        }
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
