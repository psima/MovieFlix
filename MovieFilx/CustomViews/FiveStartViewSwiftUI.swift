//
//  FiveStartViewSwiftUI.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

struct FiveStartViewSwiftUI: UIViewRepresentable {
    let rating: Int

    func makeUIView(context: Context) -> FiveStarView {
        let fiveStarView = FiveStarView()
        fiveStarView.rating = rating
        return fiveStarView
    }

    func updateUIView(_ uiView: FiveStarView, context: Context) {
        uiView.rating = rating
    }
}
