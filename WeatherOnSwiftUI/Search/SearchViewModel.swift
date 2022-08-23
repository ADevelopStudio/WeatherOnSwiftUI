//
//  SearchViewModel.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published private(set) var errorMessage: String = ""
    @Published var searchButtonState: SearchButton.StateOfButton
    @Published var textInput: String = "" {
        didSet {
            searchButtonState = textInput.isEmpty ? .disabled : .active
        }
    }
    
    private let service = ServiceManager()
    
    var onForecastFound: ((WeatherData)->())? = nil
    
    init() {
        searchButtonState = .disabled
    }
    
    func startSearching() async {
        let searchString = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchString.isEmpty {
            errorMessage = "invalid request"
            return
        }
        searchButtonState = .searching
        do {
            let result = try await service.loadData(apiPath: ApiPath.search(searchString))
            textInput = ""
            onForecastFound?(result)
        } catch {
            textInput = ""
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = ""
    }
}
