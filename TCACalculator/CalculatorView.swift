//
//  CalculatorView.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/15.
//

import SwiftUI
import ComposableArchitecture

struct CalculatorView: View {
    typealias Feat = CalculatorFeature
    let store: StoreOf<Feat>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) { vs in
            VStack {
                
            }
        }
    }
}
