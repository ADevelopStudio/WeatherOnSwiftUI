//
//  CachedImage.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 24/8/2022.
//

import Foundation
import SwiftUI

struct CachedImage: View {
    @StateObject private var manager = CachedImageManager()
    
    let url: URL?
    let animation: Animation?
    let transition: AnyTransition
    
    init(url: URL?,
         animation: Animation? = nil,
         transition: AnyTransition = .identity) {
        self.url = url
        self.animation = animation
        self.transition = transition
    }
    
    
    var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                ProgressView()
                    .transition(transition)
            case .success(let data):
                if let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .transition(transition)
                } else {
                    Image(systemName: "xmark")
                                        .symbolVariant(.circle.fill)
                                        .aspectRatio(contentMode: .fit)
                                        .transition(transition)
                }
            case .failed:
                Image(systemName: "xmark")
                                    .symbolVariant(.circle.fill)
                                    .aspectRatio(contentMode: .fit)
                                    .transition(transition)
            default:
                Image(systemName: "xmark")
                                    .symbolVariant(.circle.fill)
                                    .aspectRatio(contentMode: .fit)
                                    .transition(transition)
            }
        }
        .animation(animation, value: manager.currentState)
        .task {
            await manager.load(url)
        }
    }
}

struct CachedImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedImage(url: URL(string: "https://avatars.githubusercontent.com/u/5238454?v=4"))
    }
}

extension CachedImage {
    enum CachedImageError: Error {
        case invalidData
    }
}
