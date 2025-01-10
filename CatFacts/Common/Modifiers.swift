//
//  Modifiers.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/11/25.
//

import SwiftUI

struct BodyModifier: ViewModifier {
    var foregroundColor: Color
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Charter-Roman", size: size))
            .foregroundStyle(foregroundColor)
    }
}
