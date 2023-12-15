//
//  TCACalculatorApp.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/15.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCACalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView(store: Store(
                initialState: .init(),
                reducer: { CalculatorFeature() }))
        }
    }
}
