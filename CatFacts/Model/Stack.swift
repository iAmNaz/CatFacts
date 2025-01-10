//
//  Stack.swift
//  CatFacts
//
//  Created by Naz Mariano on 1/10/25.
//

import Foundation

/// Add and pop elements conveniently with a stack
class Stack<Element: Equatable>: ObservableObject {

    @Published private(set) var elements: [Element] = []

    // Adds a list of elements
    func add(newElements: [Element]) {
        elements.append(contentsOf: newElements)
    }
    
    // Adds an element to the top of the stack
    func push(_ element: Element) {
        elements.append(element)
    }

    // Removes and returns the top element of the stack
    @discardableResult
    func pop() -> Element? {
        return elements.popLast()
    }

    // Returns the top element without removing it
    func peek() -> Element? {
        return elements.last
    }

    // Checks if the stack is empty
    func isEmpty() -> Bool {
        return elements.isEmpty
    }

    // Returns the number of elements in the stack
    func count() -> Int {
        return elements.count
    }

    // Clears all elements in the stack
    func clear() {
        elements.removeAll()
    }
}
