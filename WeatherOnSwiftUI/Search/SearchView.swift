//
//  SearchView.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Binding var selectedForecast: WeatherData?
    
    var body: some View {
        VStack(spacing: 25) {
            ZStack {
                Color.init(white: 0.8)
                    .frame(width: 150, height: 150)
                    .cornerRadius(75)
                
                Image(systemName: "cloud.sun.rain.fill")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            HStack {
                Spacer(minLength: 10)
                
                Image(systemName: "magnifyingglass")
                    .font(Font.system(.body))
                    .foregroundColor(.init(white: 0.8))
                
                TextField("Search by cityname or postcode", text: $viewModel.textInput) { changed in
                    if changed { viewModel.clearError() }
                } onCommit: {
                    Task { await viewModel.startSearching() }
                }
                .disabled(viewModel.searchButtonState == .searching)
            }
            .frame(height: 45)
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.init(white: 0.8), style: StrokeStyle(lineWidth: 0.5)))
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }
            
            SearchButton(buttonState: $viewModel.searchButtonState) {
                Task { await viewModel.startSearching() }
            }
        }
        .padding()
        .onAppear {
            viewModel.onForecastFound = { selectedForecast = $0 }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(selectedForecast: .constant(nil))
    }
}
