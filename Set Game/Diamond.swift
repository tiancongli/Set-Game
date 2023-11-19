//
//  Diamond.swift
//  Set Game
//
//  Created by Tim Li on 19/11/2023.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let left = CGPoint(x: rect.minX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        
        path.move(to: left)
        path.addLine(to: top)
        path.addLine(to: right)
        path.addLine(to: bottom)
        path.addLine(to: left)
        return path
    }
}

#Preview {
    Diamond()
}
