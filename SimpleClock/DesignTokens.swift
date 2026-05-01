//
//  DesignTokens.swift
//  SimpleClock
//
//  Design system tokens matching SimpleClock.pen
//

import SwiftUI

// MARK: - Colors

extension Color {
    static let dsBackground = Color(light: Color(hex: 0xFAFAFA), dark: Color(hex: 0x0F0F0F))
    static let dsSurface = Color(light: Color(hex: 0xFFFFFF), dark: Color(hex: 0x1A1A1A))
    static let dsPrimary = Color(light: Color(hex: 0x1A1A1A), dark: Color(hex: 0xF5F5F5))
    static let dsSecondary = Color(light: Color(hex: 0x8A8A8A), dark: Color(hex: 0x6B6B6B))
    static let dsAccent = Color(hex: 0xFF6B35)
    static let dsBorder = Color(light: Color(hex: 0xE5E5E5), dark: Color(hex: 0x2A2A2A))
}

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }

    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

// MARK: - Typography

extension Font {
    static let dsDisplay: Font = .system(size: 96, weight: .ultraLight)
    static let dsTitle: Font = .system(size: 28, weight: .light)
    static let dsBody: Font = .system(size: 17, weight: .regular)
    static let dsCaption: Font = .system(size: 13, weight: .regular)
}

// MARK: - Spacing

enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 40
}

// MARK: - Radii

enum Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 20
}
