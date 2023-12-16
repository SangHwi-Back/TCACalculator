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
        var lh: String = "", rh: String = ""
        
        var `operator`: Operator = .addition
        
        var result: Int? = 0
    }
    
    enum Action {
        case refresh
        case setString(WritableKeyPath<State, String>, String)
        case setOperator(Operator)
        case calculateButtonClicked
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refresh:
                state.lh = ""
                state.rh = ""
                state.result = nil
                return .none
            case .setString(let keyPath, let value):
                state[keyPath: keyPath] = value
                if state[keyPath: keyPath].first == Character("0"), state[keyPath: keyPath].count > 1 {
                    state[keyPath: keyPath].removeFirst()
                }
                if state[keyPath: keyPath].last == Character("0"), state[keyPath: keyPath].count > 1 {
                    state[keyPath: keyPath].removeLast()
                }
                return .none
            case .setOperator(let `operator`):
                state.operator = `operator`
                return .none
            case .calculateButtonClicked:
                guard 
                    let lh = Int(state.lh), let rh = Int(state.rh)
                else {
                    return .none
                }
                
                if state.operator == .division, rh == 0 {
                    return .none
                }
                
                state.result = lh.calculate(state.operator, operand: rh)
                return .none
            }
        }
    }
    
    enum Operator: String, CaseIterable {
        case addition // +
        case subtraction // -
        case multiplication // *
        case division // ÷
    }
}

private extension Int {
    func calculate(
        _ `operator`: CalculatorFeature.Operator,
        operand: Int
    ) -> Int {
        switch `operator` {
        case .addition:
            return self + operand
        case .subtraction:
            return self - operand
        case .multiplication:
            return self * operand
        case .division:
            return self / operand
        }
    }
}
