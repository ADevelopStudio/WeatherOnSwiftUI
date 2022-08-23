//
//  SearchButton.swift
//  WeatherOnSwiftUI
//
//  Created by Dmitrii Zverev on 23/8/2022.
//

import SwiftUI

struct SearchButton: View {
    
    enum StateOfButton {
        case active
        case disabled
        case searching
    }
    
    @Binding var buttonState: StateOfButton
    
    var action: (()->(Void))?
    
    var body: some View {
        Button {
            self.action?()
        } label: {
            HStack(spacing: 10) {
                if buttonState.isProgressIndicatorNeeded {
                    ProgressView()
                        .tint(.white)
                }
                Text(buttonState.title)
                    .foregroundColor(.white)
            }
            .padding(20)
            .frame(height: 45)
            .background(buttonState.backgroundColor)
            .cornerRadius(8)
        }
        .disabled(buttonState != .active)
    }
}

extension SearchButton.StateOfButton {
    var backgroundColor: Color {
        switch self {
        case .disabled, .searching:
            return Color.init(white: 0.8)
        case .active:
            return .blue
        }
    }
    
    var title: String {
        switch self {
        case .searching:
            return "Please wait..."
        case .disabled, .active:
            return "Search"
        }
    }
    
    var isProgressIndicatorNeeded: Bool { self == .searching }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton(buttonState: .constant(.active))
    }
}
