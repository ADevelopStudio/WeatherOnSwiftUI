//
//  ContentView.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 22/8/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack{
            SearchView(selectedForecast: $viewModel.selectedForecast)
            
            if !viewModel.historyStorage.getSearchHistory().isEmpty {
                List {
                    ForEach(viewModel.historyStorage.getSearchHistory(), id: \.self) {
                        SearchHistoryView(viewModel: SearchHistoryViewModel(weatherData: $0), selectedForecast: $viewModel.selectedForecast)
                    }
                    .onDelete(perform: { indexset in
                        Task { await viewModel.delete(at: indexset) }
                    })
                }
            }
            
            Spacer()
        }
        .popover(isPresented: $viewModel.needToShowDetails) {
            if let selectedForecast = viewModel.selectedForecast {
                ForecastDetailView(weatherData: selectedForecast)
            } else {
                EmptyView()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


@MainActor
class ContentViewModel: ObservableObject {
    private(set) var historyStorage: HistorySearchStorage
    
    @Published var selectedForecast: WeatherData? = nil {
        didSet {
            if let newElement = selectedForecast {
                Task {
                    await historyStorage.save(data: newElement)
                    needToShowDetails = true
                }
            } else {
                needToShowDetails = false
            }
        }
    }
    @Published var needToShowDetails: Bool = false
    @Published var needToRelod: Bool = false
    
    init() {
        selectedForecast = nil
        historyStorage = HistorySearchStorage()
    }
    
    func delete(at offsets: IndexSet) async {
        await historyStorage.remove(at: offsets)
        needToRelod = true
    }
}
