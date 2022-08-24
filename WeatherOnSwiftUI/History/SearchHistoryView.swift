//
//  SearchHistoryView.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import SwiftUI

struct SearchHistoryView: View {
    @StateObject var viewModel: SearchHistoryViewModel
    @Binding var selectedForecast: WeatherData?
    
    var body: some View {
        HStack(spacing: 5) {
            CachedImage(url: viewModel.weatherData.getImageUrl(),
                        animation: .spring(),
                        transition: .slide.combined(with: .opacity))
            .frame(width: 40, height: 40)
            
            Text(viewModel.weatherData.name)
            Spacer()
            
            switch viewModel.loadingState {
            case .normal:
                Text(viewModel.weatherData.getData(type: .temperature))
            case .loading:
                ProgressView()
                Text(viewModel.weatherData.getData(type: .temperature))
            case .failedToUpdate:
                Text(viewModel.weatherData.getData(type: .temperature))
                Image(systemName: "exclamationmark.triangle.fill")
                    .symbolRenderingMode(.multicolor)
            }
        }
        .onAppear {
            viewModel.onForecastSelected = { selectedForecast = $0 }
        }
        .onTapGesture {
            viewModel.onForecastSelected?(viewModel.weatherData)
        }
        .task {
            await viewModel.update()
        }
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(viewModel: SearchHistoryViewModel(weatherData: .example), selectedForecast: .constant(.example))
    }
}
