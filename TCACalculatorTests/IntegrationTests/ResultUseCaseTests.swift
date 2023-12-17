//
//  ResultUseCaseTests.swift
//  TCACalculatorTests
//
//  Created by 백상휘 on 2023/12/17.
//

import XCTest
import ComposableArchitecture

final class ResultUseCaseTests: XCTestCase {
    func testExample() async throws {
        typealias E = ResultUseCase.UseCaseError
        let useCase = ResultUseCase()
        
        if case let .success(result) = await useCase.getResult(2, 0, op: .addition) {
            XCTAssert(result > 0)
        }
        
        if case let .failure(error) = await useCase.getResult("2", "0", op: .multiplication) {
            XCTAssertEqual(error, E.sameInput)
        }
        
        if case let .failure(error) = await useCase.getResult(0, 0, op: .addition) {
            XCTAssertEqual(error, E.twoNumberZero)
        }
        
        if case let .failure(error) = await useCase.getResult("NotNum", "0", op: .addition) {
            XCTAssertEqual(error, E.undefinedNumbers)
        }
        
        if case let .success(result) = await useCase.getResult("2", "4", op: .multiplication) {
            XCTAssert(result == 8)
        }
        
        if case let .failure(error) = await useCase.getResult("2", "0", op: .division) {
            XCTAssertEqual(error, E.divideWithZero)
        }
    }
}
