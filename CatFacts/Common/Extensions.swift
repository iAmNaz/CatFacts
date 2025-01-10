//
//  Extensions.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/9/25.
//

import Foundation
import OSLog
import Combine
import SwiftUI

extension Logger {
    func registerInfoLog(_ message: String) {
        rootLogger.info("\(message, privacy: .public)")
    }
    
    func registerErrorLog(_ message: String) {
        rootLogger.error("\(message, privacy: .public)")
    }
}

extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if finishedWithoutValue {
                            continuation.resume(throwing: AsyncError.finishedWithoutValue)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    finishedWithoutValue = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}

extension View {
    func bodyStyle(size: CGFloat = 15.0, color: Color) -> some View {
        modifier(BodyModifier(foregroundColor: color, size: size))
    }
}
