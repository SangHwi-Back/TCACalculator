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
        var textFields = IdentifiedArrayOf<CommonTextFieldFeature.State>(uniqueElements: [.init(), .init()])
        var `operator`: Operator = .addition
        var result: Int?
        
        var localError: UseCase.UseCaseError?
    }
    
    enum Action {
        case refresh
        case setOperator(Operator)
        case setLocalError(UseCase.UseCaseError)
        case setResult(Int)
        case calculateButtonClicked
        
        case fromTextField(CommonTextFieldFeature.State.ID, CommonTextFieldFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refresh:
                state.result = nil
                state.localError = nil
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
                return .run { [lh = state.textFields[0].text, rh = state.textFields[1].text, op = state.operator] send in
                    let fetch = try await useCase.getResult(lh, rh, op: op)
                    
                    switch fetch {
                    case .success(let result):
                        await send(.setResult(result))
                    case .failure(let error):
                        await send(.setLocalError(error))
                    }
                } catch: { error, send in
                    if let error = error as? UseCase.UseCaseError {
                        await send(.setLocalError(error))
                    }
                }
            default:
                return .none
            }
        }
        .forEach(\.textFields, action: /Action.fromTextField) {
            CommonTextFieldFeature()
        }
    }
}
