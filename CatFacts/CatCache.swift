//
//  CatCache.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/11/25.
//

import Foundation

protocol CatCacheProtocol {
    func next() -> CatViewModel?
}

protocol CatCacheDelegate {
    func needsRefill()
}

class CatCache: CatCacheProtocol {
    var stack: Stack<CatViewModel>!
    var delegate: CatCacheDelegate?
    private var preloadMinimum: Int
    
    init(preloadMinimum: Int = 2) {
        self.preloadMinimum = preloadMinimum
    }
    
    func next() -> CatViewModel? {
        let model = stack.pop()
        if stack.count() <= preloadMinimum {
            delegate?.needsRefill()
        }
        return model
    }
}
