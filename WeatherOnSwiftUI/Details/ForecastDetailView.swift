//
//  ForecastDetailView.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import SwiftUI

struct ForecastDetailView: View {
    @State var weatherData: WeatherData
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            
            Text(weatherData.name)
                .font(.largeTitle)
            
            if weatherData.getImageUrl(isLarge: true) != nil {
                ZStack {
                    Color.init(white: 0.9)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                    
                    CachedImage(url: weatherData.getImageUrl(isLarge: true),
                                animation: .spring(),
                                transition: .scale.combined(with: .opacity))
                    .frame(width: 75, height: 75)
                }
            }
            
            Text(weatherData.getData(type: .weatherDescr))
                .font(.headline)
            
            List(TypeOfWeatherData.unitsForDetailsView) { typeOfForecastData in
                HStack(spacing: 5) {
                    Text(typeOfForecastData.title)
                    Spacer()
                    Text(weatherData.getData(type: typeOfForecastData))
                }
            }
        }
    }
}

struct ForecastDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailView(weatherData: .example)
    }
}
