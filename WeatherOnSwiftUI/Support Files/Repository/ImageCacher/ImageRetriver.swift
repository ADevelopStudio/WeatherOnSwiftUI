//
//  ImageRetriver.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 24/8/2022.
//

import Foundation

struct ImageRetriver {
    func fetch(_ imgUrl: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: imgUrl)
        return data
    }
}
