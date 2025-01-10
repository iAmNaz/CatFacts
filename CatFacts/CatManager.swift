//
//  CatManager.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/10/25.
//

import Foundation
import Kingfisher

enum CatFetchResult {
    case photos([CatPhoto]?)
    case facts(CatFact?)
}

class CatManager: ObservableObject {
    private let catFactsApi: CatFactsAPI
    private let catCache: CatCache
    
    var stack: Stack<CatViewModel>
    
    init(catFactsApi: CatFactsAPI = .init(),
         stack: Stack<CatViewModel> = .init()) {
        self.catFactsApi = catFactsApi
        self.stack = stack
        
        self.catCache = CatCache()
        self.catCache.stack = self.stack
        self.catCache.delegate = self
    }
    
    func preloadCats() async throws {
        do {
            let models = try await loadCatsAndFacts()

            await appendModels(models)
            
            let urls = models.compactMap { URL(string: $0.image) }
            ImagePrefetcher(urls: urls).start()
            
        } catch {
            throw error
        }
    }
    
    func makeContenViewModel() -> ContentViewModel {
        ContentViewModel(self.catCache)
    }
    
    @MainActor
    private func appendModels(_ models: [CatViewModel]) {
        stack.add(newElements: models)
    }
    
    private func loadCatsAndFacts() async throws -> [CatViewModel]  {
        let catModels: [CatViewModel] = try await withThrowingTaskGroup(of: CatFetchResult.self) { taskGroup in
            taskGroup.addTask { [unowned self] in
                do {
                    guard let catPhotos = try await catFactsApi.getCatPhotos(10) else {
                        return .photos([])
                    }
                    
                    return .photos(catPhotos)
                } catch {
                    throw error
                }
            }
            
            taskGroup.addTask { [unowned self] in
                do {
                    guard let catFacts = try await catFactsApi.getCatFacts(8) else {
                        return .facts(nil)
                    }
                    
                    return .facts(catFacts)
                } catch {
                    throw error
                }
            }
            
            var photos: [CatPhoto]?
            var facts: CatFact?
            
            do {
                for try await value in taskGroup {
                    switch value {
                    case .photos(let value):
                        photos = value
                    case .facts(let value):
                        facts = value
                    }
                }
            } catch {
                throw error
            }
            
            var models: [CatViewModel] = []
            
            if let photos = photos, let facts = facts, facts.facts.count > 0 {
                photos.enumerated().forEach { (index, photo) in
                    guard index <= facts.facts.count - 1 else {
                        return
                    }
                    
                    let fact = facts.facts[index]
                    models.append(.init(image: photo.url, fact: fact))
                }
            } else {
                return models
            }
            
            return models
        }
        
        return catModels
    }
}

extension CatManager: CatCacheDelegate {
    func needsRefill() {
        Task {
            do {
                try await self.preloadCats()
            } catch {
                //TODO: Broadcast error
            }
        }
    }
}
