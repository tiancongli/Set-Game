//
//  Card.swift
//  Set Game
//
//  Created by Tim Li on 22/11/2023.
//

import Foundation
import SwiftUI

struct Card<ShadingType, ShapeType> : Identifiable {
    var id: String
    
    let shapeNum: Int
    let color: Color
    let shadingType: ShadingType
    let shapeType: ShapeType
    
    init(shapeNum: Int, color: Color, shadingType: ShadingType, shapeType: ShapeType) {
        self.id = "\(shapeNum) \(color) \(shadingType) \(shapeType)"
        self.shapeNum = shapeNum
        self.color = color
        self.shadingType = shadingType
        self.shapeType = shapeType
    }
}
