//
//  CommonTextFieldFeature.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/16.
//

import Foundation
import ComposableArchitecture

struct CommonTextFieldFeature: Reducer {
    struct State: Equatable, Identifiable {
        var id = UUID()
        var text: String = ""
        var prompt: String?
    }
    
    enum Action {
        case setString(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setString(let value):
                state.text = value
                if state.text.first == Character("0"), state.text.count > 1 {
                    state.text.removeFirst()
                }
                if state.text.last == Character("0"), state.text.count > 1 {
                    state.text.removeLast()
                }
                return .none
            }
        }
    }
}
