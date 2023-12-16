//
//  CommonTextField.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/16.
//

import SwiftUI
import ComposableArchitecture

struct CommonTextField: View {
    typealias Feat = CommonTextFieldFeature
    let store: StoreOf<Feat>
    var body: some View {
        WithViewStore(store, observe: {$0}) { vs in
            TextField(
                text: vs.binding(get: \.text, send: { .setString($0) }),
                prompt: Text(vs.prompt ?? "")
            ) {
                EmptyView()
            }
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .border(.secondary)
        }
    }
}
