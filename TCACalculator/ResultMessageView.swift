//
//  ResultMessageView.swift
//  TCACalculator
//
//  Created by 백상휘 on 2023/12/15.
//

import SwiftUI

struct ResultMessageView: View {
    let result: Int
    var body: some View {
        Text("Result Accepted \(result)")
    }
}

#Preview {
    ResultMessageView(result: 0)
}
