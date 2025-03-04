//
//  DetailInfoTitleModifier.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 26/2/25.
//

import SwiftUI

struct DetailInfoTitleModifier: ViewModifier {
    var fontSize: CGFloat = 14
    func body(content: Content) -> some View {
        content
            .font(.title3.weight(.bold))
            .foregroundStyle(.blue)
    }
}

extension View {
    func applyDetailTitleFont() -> some View {
        modifier(DetailInfoTitleModifier())
    }
}
