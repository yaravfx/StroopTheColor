//
//  ShakeEffect.swift
//  StroopTheColor
//
//  Created by Yara on 2026-01-17.
//
import SwiftUI

struct Shake: GeometryEffect {
    
    var amount: CGFloat = 10
    var shakePerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX:amount * sin(animatableData * .pi * CGFloat(shakePerUnit)),
            y: 0))
    }
    
}
