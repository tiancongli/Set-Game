//
//  CardView.swift
//  Set Game
//
//  Created by Tim Li on 18/11/2023.
//

import SwiftUI

struct CardView: View, Animatable {
    let card: SetGameCard
    let status: SetGame.CardStatus
    let faceUp: Bool
    
    var rotation: Double
    
    var offset: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(rotation, offset)
        }

        set {
            rotation = newValue.first
            offset = newValue.second
        }
    }
    
    init(_ card: SetGameCard, status: Status = Status.unselected, faceUp: Bool = true) {
        self.card = card
        self.status = status
        self.faceUp = faceUp
        self.rotation = status == .matched ? 180 : 0
        self.offset = status == .notMatched ? -1.6 : 0
    }
    
    var body: some View {
        ZStack {
            container
            if faceUp {
                cardShapes
            }
        }
        .aspectRatio(Constants.ASPECT_RATIO, contentMode: .fit)
        .rotationEffect(.degrees(rotation))
        .offset(x: offset)
        .animation(status == .notMatched ? shakeAnimation : nil, value: offset)
        
    }
    
    private var shakeAnimation: Animation {
        .default.repeatCount(9, autoreverses: true).speed(15)
    }
    
    private var color: Color {
        switch status {
        case .unselected:
            return .white
        case .selected:
            return .blue.opacity(Constants.CARD_SELECTED_OPACITY)
        case .matched:
            return .green.opacity(Constants.CARD_SELECTED_OPACITY)
        case .notMatched:
            return .red.opacity(Constants.CARD_SELECTED_OPACITY)
        }
    }
    
    private var container: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.CORNER_RADIUS)
                .fill((faceUp ? color : .orange).opacity(Constants.Container.OPACITY))
                .stroke(.blue, lineWidth: 2)
                .shadow(color: .gray,
                        radius: Constants.Container.Shadow.RADIUS,
                        x: Constants.Container.Shadow.X,
                        y: Constants.Container.Shadow.Y)
        }
        
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
        static let CARD_SELECTED_OPACITY = 0.8

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

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: 1).repeatForever(autoreverses: false)
    }
}

typealias Status = SetGame.CardStatus

#Preview {
    CardView(Card(shapeNum: 6,
                  color: .green,
                  shadingType: SetGame.ShadingType.semiTransparent,
                  shapeType: SetGame.ShapeType.oval))
    .padding()
}
