//
//  CalculatorFeature.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/15.
//

import Foundation
import ComposableArchitecture

struct CalculatorFeature: Reducer {
    typealias UseCase = ResultUseCase
    typealias Operator = ResultUseCase.Operator
    @Dependency(\.resultUseCase) var useCase: UseCase
    
    struct State: Equatable {
        var lh: String = "", rh: String = ""
        var `operator`: Operator = .addition
        var result: Int? = 0
        
        var localError: UseCase.UseCaseError?
    }
    
    enum Action {
        case refresh
        case setString(WritableKeyPath<State, String>, String)
        case setOperator(Operator)
        case setLocalError(UseCase.UseCaseError)
        case setResult(Int)
        case calculateButtonClicked
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refresh:
                state.lh = ""
                state.rh = ""
                state.result = nil
                state.localError = nil
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
            case .setLocalError(let error):
                state.localError = error
                return .none
            case .setResult(let result):
                state.result = result
                return .none
            case .calculateButtonClicked:
                return .run { [lh = state.lh, rh = state.rh, op = state.operator] send in
                    let fetch = try await useCase.getResult(lh, rh, op: op)
                    
                    switch fetch {
                    case .success(let result):
                        await send(.setResult(result))
                    case .failure(let error):
                        await send(.setLocalError(error))
                    }
                }
            }
        }
    }
}
