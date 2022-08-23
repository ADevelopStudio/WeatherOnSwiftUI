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
                    Color.init(white: 0.8)
                        .frame(width: 100, height: 100)
                        .cornerRadius(50)
                    
                    AsyncImage(url: weatherData.getImageUrl(isLarge: true)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 75, height: 75)
                }
            }
            
            List(TypeOfWeatherData.allCases) { typeOfForecastData in
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