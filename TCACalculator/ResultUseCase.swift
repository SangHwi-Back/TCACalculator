//
//  ResultUseCase.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/16.
//

import Foundation
import ComposableArchitecture

class ResultUseCase {
    private let isTestable: Bool
    private var cache: (lh: Int?, rh: Int?)
    
    init(isTestable: Bool = false) {
        self.isTestable = isTestable
    }
    
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
    
    func getResult(_ lh: Int, _ rh: Int, op: Operator) async -> Result<Int, UseCaseError> {
        await withCheckedContinuation { continuation in
            self.calculate(lh: lh, rh: rh, op: op) {
                continuation.resume(returning: $0)
            }
        }
    }
    
    func getResult(_ lh: String, _ rh: String, op: Operator) async -> Result<Int, UseCaseError> {
        await withCheckedContinuation { continuation in
            guard let lh = Int(lh), let rh = Int(rh) else {
                continuation.resume(returning: .failure(UseCaseError.undefinedNumbers))
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
            return
        }
        if lh == 0, rh == 0 {
            completionHandler(Result.failure(UseCaseError.twoNumberZero))
            return
        }
        
        let interval = DispatchTimeInterval.seconds(isTestable ? 0 : Int.random(in: 0...3))
        
        DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
            guard (op == .division && rh == 0) == false else {
                completionHandler(Result.failure(UseCaseError.divideWithZero))
                return
            }
            
            self.cache = (lh, rh)
            completionHandler(Result.success(lh.calculate(op, operand: rh)))
        }
    }
}


extension ResultUseCase: DependencyKey {
    static var liveValue: ResultUseCase = .init()
    static var testValue: ResultUseCase = .init(isTestable: true)
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
