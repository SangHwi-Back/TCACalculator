//
//  CalculatorFeature.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/15.
//

import Foundation
import ComposableArchitecture

struct CalculatorFeature: Reducer {
    struct State: Equatable {
        var lh: Float = 0
        var rh: Float = 0
        
        var `operator`: Operator = .addition
    }
    
    enum Action {
        case setFloat(WritableKeyPath<State, Float>, Float)
        case setOperator(Operator)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
    }
    
    enum Operator {
        case addition // +
        case subtraction // -
        case multiplication // *
        case division // ÷
    }
}
