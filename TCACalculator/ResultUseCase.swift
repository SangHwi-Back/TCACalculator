//
//  ResultUseCase.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/16.
//

import Foundation
import ComposableArchitecture

class ResultUseCase {
    
    var cache: (lh: Int?, rh: Int?)
    
    enum Operator: String, CaseIterable {
        case addition // +
        case subtraction // -
        case multiplication // *
        case division // ÷
    }
    
    enum UseCaseError: Error {
        case divideWithZero
        case twoNumberZero
        case sameInput
        case undefinedNumbers
    }
    
    func getResult(_ lh: Int, _ rh: Int, op: Operator) async throws -> Result<Int, UseCaseError> {
        try await withCheckedThrowingContinuation { continuation in
            self.calculate(lh: lh, rh: rh, op: op) {
                continuation.resume(returning: $0)
            }
        }
    }
    
    func getResult(_ lh: String, _ rh: String, op: Operator) async throws -> Result<Int, UseCaseError> {
        try await withCheckedThrowingContinuation { continuation in
            guard let lh = Int(lh), let rh = Int(rh) else {
                continuation.resume(throwing: UseCaseError.undefinedNumbers)
                return
            }
            
            self.calculate(lh: lh, rh: rh, op: op) {
                continuation.resume(returning: $0)
            }
        }
    }
    
    private func calculate(lh: Int, rh: Int, op: Operator, completionHandler: @escaping (Result<Int, UseCaseError>) -> Void) {
        if cache.lh == lh && cache.rh == rh {
            completionHandler(Result.failure(UseCaseError.sameInput))
        }
        if lh == 0, rh == 0 {
            completionHandler(Result.failure(UseCaseError.twoNumberZero))
        }
        
        let interval = DispatchTimeInterval.seconds(Int.random(in: 0...3))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
            if op == .division, rh == 0 {
                completionHandler(Result.failure(UseCaseError.divideWithZero))
            }
            
            completionHandler(Result.success(lh.calculate(op, operand: rh)))
        }
    }
}


extension ResultUseCase: DependencyKey {
    static var liveValue: ResultUseCase = .init()
}

extension DependencyValues {
    var resultUseCase: ResultUseCase {
        get { self[ResultUseCase.self] }
        set { self[ResultUseCase.self] = newValue }
    }
}

private extension Int {
    func calculate(
        _ `operator`: ResultUseCase.Operator,
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
