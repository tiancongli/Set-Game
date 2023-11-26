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
    
    init() {
        self.model = GameCards(SetGame.generateCards())
        dealCards()
    }
    
    func reset() {
        self.model = GameCards(SetGame.generateCards())
        dealCards()
    }
    
    static private func generateCards () -> [SetGameCard] {
        var cards: [SetGameCard] = []
        ShadingType.allCases.forEach {shadingType in
            ShapeType.allCases.forEach {shapeType in
                Constants.nums.forEach {num in
                    Constants.colors.forEach {color in
                        cards.append(Card(shapeNum: num, color: color, shadingType: shadingType, shapeType: shapeType))
                    }
                }
            }
        }
        return cards.shuffled()
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
        (0..<Constants.extraCardsNum).forEach {_ in
            model.dealCard()
        }
    }
    
    enum ShadingType: CaseIterable {
        case transparent, semiTransparent, solid
    }
    
    enum ShapeType: CaseIterable {
        case diamond, rectangle, oval
    }
    
    struct Constants {
        static let colors: [Color] = [.green, .red, .yellow]
        static let nums = [1, 2, 3]
        static let totalCardsOnTable = 12
        static let extraCardsNum = 3
    }
}

typealias SetGameCard = Card<SetGame.ShadingType, SetGame.ShapeType>
