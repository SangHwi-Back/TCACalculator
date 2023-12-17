//
//  TCACalculatorTests.swift
//  TCACalculatorTests
//
//  Created by 백상휘 on 2023/12/15.
//

import XCTest
import ComposableArchitecture

final class TCACalculatorTests: XCTestCase {
    @MainActor
    func testExample() async throws {
        let store = TestStore(initialState: CalculatorFeature.State()) {
            CalculatorFeature()
        }
        
        await store.send(.refresh)
        
        await store.send(.setOperator(.multiplication)) { state in
            state.operator = .multiplication
        }
        
        await store.send(.setResult(5)) { state in
            state.result = 5
        }
    }
    
    @MainActor
    func testDivisionError() async throws {
        let store = TestStore(initialState: CalculatorFeature.State(textFields: .init(uniqueElements: [
            .init(),
            .init(text: "0")
        ]))) {
            CalculatorFeature()
        }
        
        await store.send(.calculateButtonClicked)
        await store.receive(/CalculatorFeature.Action.setLocalError) { state in
            state.localError = .undefinedNumbers
        }
    }
    
    @MainActor
    func testFailed() async throws {
        let store = TestStore(initialState: CalculatorFeature.State(textFields: .init(uniqueElements: [
            .init(text: "2"),
            .init(text: "0")
        ]))) {
            CalculatorFeature()
        }
        
        await store.send(.setOperator(.division)) { state in
            state.operator = .division
        }
        
        await store.send(.calculateButtonClicked).finish()
        await store.receive(/CalculatorFeature.Action.setLocalError) { state in
            state.localError = .divideWithZero
        }
    }
}
