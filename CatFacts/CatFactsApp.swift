//
//  CatFactsApp.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import SwiftUI

@main
struct CatFactsApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var catManager: CatManager = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: catManager.makeContenViewModel())
        }
        .onChange(of: scenePhase, { oldPhase, newPhase in
            if newPhase == .active {
                Task {
                    do {
                        try await catManager.preloadCats()
                    } catch {
                        //TODO: Broadcast error
                    }
                }
            }
        })
    }
}
