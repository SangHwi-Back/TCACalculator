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
                HStack {
                    ForEachStore(
                        store.scope(state: \.textFields, action: Feat.Action.fromTextField)
                    ) { textFieldStore in
                        CommonTextField(store: textFieldStore)
                    }
                    
                    Picker(
                        Feat.Operator.addition.rawValue,
                        selection: vs.binding(get: \.operator, send: { .setOperator($0) })
                    ) {
                        ForEach(Feat.Operator.allCases, id: \.self) { op in
                            Text(op.rawValue)
                                .lineLimit(1)
                        }
                    }
                    .foregroundStyle(.secondary)
                    .pickerStyle(.wheel)
                    .buttonStyle(BorderedButtonStyle())
                    .minimumScaleFactor(0.2)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                
                Button("Calculate!", systemImage: "rectangle.portrait.and.arrow.forward.fill") {
                    vs.send(.calculateButtonClicked)
                }
                .foregroundStyle(.primary)
                .buttonStyle(BorderedButtonStyle())
            }
            .onAppear(perform: { vs.send(.refresh) })
            .navigationDestination(isPresented: .constant(vs.result != nil)) {
                ResultMessageView(result: vs.result ?? 0)
            }
        }
        .navigationTitle("Calculator")
    }
    
    struct TextFieldArea: View {
        @Binding var text: String
        var prompt: String
        
        var body: some View {
            TextField(text: $text, prompt: Text(prompt)) {
                EmptyView()
            }
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .border(.secondary)
        }
    }
}

#Preview {
    NavigationView {
        CalculatorView(store: Store(
            initialState: .init(),
            reducer: { CalculatorFeature() }))
    }
}
