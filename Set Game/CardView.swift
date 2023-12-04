//
//  CardView.swift
//  Set Game
//
//  Created by Tim Li on 18/11/2023.
//

import SwiftUI

struct CardView: View {
    let card: SetGameCard
    let color: Color?
    let bgColor: Color?
    
    var body: some View {
        ZStack {
            container
            cardShapes
        }
        .aspectRatio(Constants.ASPECT_RATIO, contentMode: .fit)
        .padding()
        .background(bgColor)
    }
    
    init(_ card: SetGameCard, color: Color? = .white, bgColor: Color? = .white) {
        self.card = card
        self.color = color
        self.bgColor = bgColor
    }
    
    @ViewBuilder
    private var container: some View {
        RoundedRectangle(cornerRadius: Constants.CORNER_RADIUS)
            .fill(color!.opacity(Constants.Container.OPACITY))
            .shadow(color: .gray,
                    radius: Constants.Container.Shadow.RADIUS, 
                    x: Constants.Container.Shadow.X,
                    y: Constants.Container.Shadow.Y)
    }
    
    private var cardShapes: some View {
        VStack {
            ForEach(1..<card.shapeNum + 1, id: \.self) {_ in
                Spacer()
                cardShape
                Spacer()
            }
        }
        .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
        .padding()
        
    }
    
    @ViewBuilder private var cardShape: some View {
        let shape = getShapeFromType()
        applyShadingType(shape)
    }
    
    private func getShapeFromType() -> some Shape {
        switch card.shapeType {
        case .diamond:
            AnyShape(Diamond())
        case .rectangle:
            AnyShape(Rectangle())
        case .oval:
            AnyShape(RoundedRectangle(cornerRadius: Constants.CardShape.CORNER_RADIUS))
        }
    }
    
    private func applyShadingType(_ shape: some Shape) -> some View {
        switch card.shadingType {
        case .transparent:
            return AnyView(shape
                .stroke(card.color, lineWidth: Constants.CardShape.BORDER_SIZE)
                .fill(.white)
                .aspectRatio(Constants.CardShape.ASPECT_RATIO, contentMode: .fit)
            )
        case .solid:
            return AnyView(shape
                .foregroundStyle(card.color)
                .aspectRatio(Constants.CardShape.ASPECT_RATIO, contentMode: .fit)
            )
        case .semiTransparent:
            return AnyView(shape
                .foregroundStyle(card.color)
                .opacity(Constants.CardShape.OPACITY)
                .aspectRatio(Constants.CardShape.ASPECT_RATIO, contentMode: .fit)
            )
        }
    }
    
    struct Constants {
        static let CORNER_RADIUS = 25.0
        static let ASPECT_RATIO: CGFloat = 2/3

        struct Container {
            static let OPACITY = 0.9
            struct Shadow {
                static let RADIUS: CGFloat = 5
                static let X: CGFloat = 2
                static let Y: CGFloat = 5
            }
        }
        struct CardShape {
            static let OPACITY = 0.2
            static let BORDER_SIZE: CGFloat = 4
            static let ASPECT_RATIO: CGFloat = 2
            static let CORNER_RADIUS = 50.0
        }
    }
}

#Preview {
    CardView(Card(shapeNum: 6,
                  color: .green,
                  shadingType: SetGame.ShadingType.semiTransparent,
                  shapeType: SetGame.ShapeType.oval))
}
