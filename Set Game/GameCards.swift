//
//  GameCards.swift
//  Set Game
//
//  Created by Tim Li on 22/11/2023.
//

import Foundation

struct GameCards<ShadingType, ShapeType> {
    typealias GameCard = Card<ShadingType, ShapeType>
    
    private(set) var deckCards: [GameCard]
    private(set) var tableCards: [GameCard]
    private(set) var selectedCards: [GameCard]
    
    init(_ deckCards: [GameCard]) {
        self.deckCards = deckCards
        self.tableCards = []
        self.selectedCards = []
    }
    
    mutating func choose(_ card: GameCard) {
        if let cardIndex = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: cardIndex)
        } else if tableCards.contains(card) {
            selectedCards.append(card)
        }
    }
    
    mutating func emptySelectedCards() {
        selectedCards = []
    }
    
    mutating func dealCards(_ num: Int) {
        while tableCards.count < num && !deckCards.isEmpty{
            dealCard()
        }
    }
    
    mutating func dealCard() {
        let card = deckCards.removeLast()
        tableCards.append(card)
    }
    
    mutating func replaceCards(_ cards: [GameCard]) {
        for card in cards {
            replaceCard(card)
        }
    }
    
    mutating func replaceCard(_ card: GameCard) {
        if let cardIndex = tableCards.firstIndex(of: card) {
            if deckCards.isEmpty {
                tableCards.remove(at: cardIndex)
            } else {
                tableCards[cardIndex] = deckCards.removeLast()
            }
        }
    }
    
    mutating func endGame() {
        tableCards = []
        deckCards = []
        selectedCards = []
    }
    
    
}


