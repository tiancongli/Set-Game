//
//  CardsPileView.swift
//  Set Game
//
//  Created by timli on 17/12/2023.
//

import SwiftUI

struct CardsPileView: View {
    let cards: [SetGameCard]
    
    let faceUp: Bool
    
    var ns: Namespace.ID
    
    let maxCardsNum = 5
    
    init(_ cards: [SetGameCard], ns: Namespace.ID, faceUp: Bool = false) {
        self.cards = cards
        self.ns = ns
        self.faceUp = faceUp
    }
    
    var body: some View {
        ZStack {
            let cardsNum = cards.count
            let visualCardsNum = cardsNum > maxCardsNum ? maxCardsNum : cardsNum
            
            ForEach((cardsNum-visualCardsNum)..<cardsNum, id: \.self) { index in
                CardView(cards[index], faceUp: faceUp)
                    .zIndex(Double(index))
                    .offset(CGSize(width: (cardsNum - index) * 5, height: 0))
                    .matchedGeometryEffect(id: cards[index].id, in: ns)
                
            }
        }
    }
}


#Preview {
    
    CardsPileView([
        Card(shapeNum: 6,
             color: .green,
             shadingType: SetGame.ShadingType.semiTransparent,
             shapeType: SetGame.ShapeType.oval),
        Card(shapeNum: 5,
             color: .green,
             shadingType: SetGame.ShadingType.semiTransparent,
             shapeType: SetGame.ShapeType.oval),
        Card(shapeNum: 4,
             color: .green,
             shadingType: SetGame.ShadingType.semiTransparent,
             shapeType: SetGame.ShapeType.oval),
        Card(shapeNum: 3,
             color: .green,
             shadingType: SetGame.ShadingType.semiTransparent,
             shapeType: SetGame.ShapeType.oval),
        Card(shapeNum: 2,
             color: .green,
             shadingType: SetGame.ShadingType.semiTransparent,
             shapeType: SetGame.ShapeType.oval),
    ], ns: Namespace().wrappedValue)
        .padding(100)
        .background(.blue)
}
