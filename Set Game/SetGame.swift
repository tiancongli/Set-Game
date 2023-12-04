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
        if selectedCards.count == Constants.cardsInSet {
            if isSet(selectedCards) {
                model.replaceCards(selectedCards)
            }
            model.emptySelectedCards()
        }
        model.choose(card)
        
        if isEndGame() {
            model.endGame()
        }
        
    }
    
    func isEndGame() -> Bool {
        return model.deckCards.isEmpty && selectedCards.count == model.tableCards.count
    }
    
    func getCardColor(_ card: SetGameCard) -> Color {
        return selectedCards.contains(card) ? .blue : .white
    }
    
    func getCardBgColor(_ card: SetGameCard) -> Color {
        switch getCardStatus(card) {
        case .notDecided:
            return .white
        case .matched:
            return .green
        case .notMatched:
            return .red
        }
    }
    
    func isSet(_ cards: [SetGameCard]) -> Bool {
        guard cards.count == Constants.cardsInSet else {return false}
        // FOR TEST ONLY: return true
        let isFeatureSet = { (featureExtractor: (SetGameCard) -> AnyHashable) in
            let featureSet = Set(cards.map(featureExtractor))
            return featureSet.count != Constants.cardsInSet - 1
        }

        return isFeatureSet { $0.color } && isFeatureSet { $0.shapeType } &&
        isFeatureSet { $0.shapeNum } && isFeatureSet { $0.shadingType }
    }
    
    private func getCardStatus(_ card: SetGameCard) -> CardStatus {
        // If the card is not selected or if the number of selected cards
        // doesn't make a complete set yet, the status is 'notDecided'.
        if !selectedCards.contains(card) || selectedCards.count != Constants.cardsInSet {
            return .notDecided
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
    
    func dealCards () {
        model.dealCards(Constants.totalCardsOnTable)
    }
    
    func deal3More() {
        (0..<Constants.cardsInSet).forEach {_ in
            model.dealCard()
        }
    }
    
    enum ShadingType: CaseIterable {
        case transparent, semiTransparent, solid
    }
    
    enum ShapeType: CaseIterable {
        case diamond, rectangle, oval
    }
    
    enum CardStatus {
        case notDecided, matched, notMatched
    }
    
    struct Constants {
        static let cardsInSet = 3
        static let colors: [Color] = [.green, .red, .yellow]
        static let nums = [1, 2, 3]
        static let totalCardsOnTable = 12
    }
}

typealias SetGameCard = Card<SetGame.ShadingType, SetGame.ShapeType>
