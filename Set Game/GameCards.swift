//
//  GameCards.swift
//  Set Game
//
//  Created by Tim Li on 22/11/2023.
//

import Foundation

struct GameCards<ShadingType, ShapeType> {
    private(set) var deckCards: [Card<ShadingType, ShapeType>]
    private(set) var tableCards: [Card<ShadingType, ShapeType>]
    
    init(_ deckCards: [Card<ShadingType, ShapeType>]) {
        self.deckCards = deckCards
        self.tableCards = []
    }
    
    mutating func dealCards (_ num: Int) {
        while tableCards.count < num && !deckCards.isEmpty{
            dealCard()
        }
    }
    
    mutating func dealCard () {
        let card = deckCards.removeLast()
        tableCards.append(card)
    }
}
