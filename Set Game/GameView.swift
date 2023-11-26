//
//  GameView.swift
//  Set Game
//
//  Created by Tim Li on 22/11/2023.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: SetGame
    
    init(_ viewModel: SetGame) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            cards
            Spacer()
            controller
        }
        .padding()
    }
    
    var cards: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.tableCards) { card in
                    CardView(card)
                }
            }
        }
    }
    
    var controller: some View {
        HStack {
            Button("3 More", action: viewModel.deal3More)
            Spacer()
            Button("New Game", action: viewModel.reset)
        }
        
    }
}

#Preview {
    GameView(SetGame())
}
