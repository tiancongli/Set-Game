//
//  GameView.swift
//  Set Game
//
//  Created by Tim Li on 22/11/2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: SetGame
    
    @Namespace private var cardsMoving
    
    init(_ viewModel: SetGame) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                CardsPileView(viewModel.discardedCards, ns: cardsMoving)
                Spacer()
                CardsPileView(viewModel.deckCards, ns: cardsMoving)
            }
            .frame(height: 100)
            .padding()
            cards
            Spacer()
            controller
        }
        .padding()
    }
    
    var cards: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: Constants.cardsPadding.0) {
                ForEach(viewModel.tableCards) { card in
                    let color = viewModel.getCardColor(card)
                    CardView(card, color: color)
                        .onTapGesture {
                            withAnimation {
                                viewModel.choose(card)
                            }
                        }
                        .padding(Constants.cardsPadding.1)
                        .matchedGeometryEffect(id: card.id, in: cardsMoving)
                }
            }
        }
    }
    
    var controller: some View {
        HStack {
            Button("Shuffle") {
                withAnimation {
                    viewModel.shuffle()
                }
            }
            Spacer()
            Button("New Game", action: viewModel.reset)
        }
        
    }
    
    struct Constants {
        static let cardsPadding = (CGFloat(20), CGFloat(5))
        
    }
}

#Preview {
    GameView(SetGame())
}
