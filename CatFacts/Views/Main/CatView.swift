//
//  CatView.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/10/25.
//

import SwiftUI
import Kingfisher

class CatViewModel: Equatable {
    let image: String
    let fact: String
    
    init(image: String, fact: String) {
        self.image = image
        self.fact = fact
    }
    
    static func ==(lhs: CatViewModel, rhs: CatViewModel) -> Bool {
        return lhs.image == rhs.image
    }
}

struct CatView: View {
    var viewModel: CatViewModel
    
    var body: some View {
        VStack {
            KFImage(URL(string: viewModel.image)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text(viewModel.fact)
                .bodyStyle(color: .black)
                .lineSpacing(5)
                .padding()
        }
    }
}
