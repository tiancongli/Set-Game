//
//  SetGame.swift
//  Set Game
//
//  Created by Tim Li on 22/11/2023.
//

import Foundation
import SwiftUI

class SetGame: ObservableObject {
    @Published private var model: GameCards<ShadingType, ShapeType>
    
    var selectedCards: [SetGameCard] {
        model.selectedCards
    }
    
    init() {
        self.model = GameCards(SetGame.generateCards())
        dealCards()
    }
    
    func reset() {
        self.model = GameCards(SetGame.generateCards())
        dealCards()
    }
    
    func choose(_ card: SetGameCard) {
        checkIfMatch(matchHandler: discardSelectedCards)
        model.choose(card)
        
        // if the chosen card is the last one on the table, then check match set again
        if model.tableCards.count == Constants.cardsInSet {
            checkIfMatch(matchHandler: discardSelectedCards)
        }
        
        if isEndGame() {
            model.endGame()
        }
    }
    
    func deal() {
        selectedCards.count == Constants.cardsInSet ? checkIfMatch(matchHandler: replaceSelectedCards) : dealMore()
        
        if isEndGame() {
            model.endGame()
        }
    }
    
    func discardSelectedCards() {
        model.discardCards(selectedCards)
    }
    
    func replaceSelectedCards() {
        model.replaceCards(selectedCards)
    }
    
    func checkIfMatch(matchHandler: () -> Void) {
        if selectedCards.count == Constants.cardsInSet {
            if isSet(selectedCards) {
                matchHandler()
            }
            model.emptySelectedCards()
        }
    }
    
    func isEndGame() -> Bool {
        return model.deckCards.isEmpty && selectedCards.count == model.tableCards.count
    }
    
    func isSet(_ cards: [SetGameCard]) -> Bool {
        guard cards.count == Constants.cardsInSet else {return false}
//         FOR TEST ONLY: 
//        return true
        let isFeatureSet = { (featureExtractor: (SetGameCard) -> AnyHashable) in
            let featureSet = Set(cards.map(featureExtractor))
            return featureSet.count != Constants.cardsInSet - 1
        }

        return isFeatureSet { $0.color } && isFeatureSet { $0.shapeType } &&
        isFeatureSet { $0.shapeNum } && isFeatureSet { $0.shadingType }
    }
    
    func getCardStatus(_ card: SetGameCard) -> CardStatus {
        if !selectedCards.contains(card) {
            return .unselected
        }
        
        if selectedCards.count != Constants.cardsInSet {
            return .selected
        }

        // If the card is part of a selected set, determine if the cards form a set.
        return isSet(selectedCards) ? .matched : .notMatched
    }
    
    static private func generateCards () -> [SetGameCard] {
        var cards: [SetGameCard] = []
        forEachFeature { shadingType, shapeType, num, color in
        // FOR TEST ONLY: if cards.count < 6 {
                cards.append(Card(shapeNum: num, color: color, shadingType: shadingType, shapeType: shapeType))
        // }
        }
        
        return cards.shuffled()
    }
    
    static private func forEachFeature(_ op: (ShadingType, ShapeType, Int, Color) -> Void) {
        ShadingType.allCases.forEach {shadingType in
            ShapeType.allCases.forEach {shapeType in
                Constants.nums.forEach {num in
                    Constants.colors.forEach {color in
                        op(shadingType, shapeType, num, color)
                    }
                }
            }
        }
    }
    
    
    var tableCards: [SetGameCard]  {
        model.tableCards
    }
    
    var deckCards: [SetGameCard] {
        model.deckCards
    }
    
    var discardedCards: [SetGameCard] {
        model.discardedCards
    }
    
    func dealCards () {
        model.dealCards(Constants.totalCardsOnTable)
    }
    
    func dealMore() {
        (0..<Constants.cardsInSet).forEach {_ in
            model.dealCard()
        }
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    enum ShadingType: CaseIterable {
        case transparent, semiTransparent, solid
    }
    
    enum ShapeType: CaseIterable {
        case diamond, rectangle, oval
    }
    
    enum CardStatus {
        case unselected, selected, matched, notMatched
    }
    
    struct Constants {
        static let cardsInSet = 3
        static let colors: [Color] = [.green, .red, .yellow]
        static let nums = [1, 2, 3]
        static let totalCardsOnTable = 12
        static let cardSelectedOpacity = 0.8
    }
}

typealias SetGameCard = Card<SetGame.ShadingType, SetGame.ShapeType>
