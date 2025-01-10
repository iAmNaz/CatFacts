//
//  ContentView.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var catViewModel: CatViewModel?
    @Published var isBusy = false
    
    var buttonTitle: String = "Purrs me to start"
    
    private var catCache: CatCacheProtocol
    
    init(_ catCache: CatCacheProtocol) {
        self.catCache = catCache
    }
    
    func next() {
        catViewModel = catCache.next()
    }
}

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            if let viewModel = viewModel.catViewModel {
                ScrollView {
                    CatView(viewModel: viewModel)
                }
            } else {
                Button {
                    viewModel.next()
                } label: {
                    Text("Purrs me to start")
                        .foregroundStyle(.brown)
                        .font(.title)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            viewModel.next()
        }
    }
}
