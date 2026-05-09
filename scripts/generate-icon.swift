#!/usr/bin/env swift
//
// scripts/generate-icon.swift
//
// Renders three app icon variants (light, dark, tinted) at 1024×1024 using
// CoreGraphics + CoreText. Run from repo root:
//
//   swift scripts/generate-icon.swift
//
// Writes PNGs to SimpleClock/SimpleClock/Assets.xcassets/AppIcon.appiconset/

import CoreGraphics
import CoreText
import Foundation
import ImageIO

// MARK: - Color helpers

let deviceRGB = CGColorSpaceCreateDeviceRGB()

func cgColor(hex: UInt32) -> CGColor {
    CGColor(colorSpace: deviceRGB, components: [
        CGFloat((hex >> 16) & 0xFF) / 255,
        CGFloat((hex >> 8)  & 0xFF) / 255,
        CGFloat( hex        & 0xFF) / 255,
        1.0,
    ])!
}

// MARK: - Font

func makeFont(_ size: CGFloat) -> CTFont {
    CTFontCreateWithName("HelveticaNeue-UltraLight" as CFString, size, nil)
}

func measureWidth(_ text: String, font: CTFont) -> CGFloat {
    let ms = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)!
    CFAttributedStringReplaceString(ms, CFRangeMake(0, 0), text as CFString)
    CFAttributedStringSetAttribute(ms, CFRangeMake(0, CFStringGetLength(text as CFString)),
                                   kCTFontAttributeName, font)
    var asc: CGFloat = 0, desc: CGFloat = 0, lead: CGFloat = 0
    return CGFloat(CTLineGetTypographicBounds(CTLineCreateWithAttributedString(ms), &asc, &desc, &lead))
}

// MARK: - Scale from app proportions
//
// App: 96pt display font, Spacing.sm = 8pt gap, SeparatorDots = 8×8pt circles, 18pt gap
// Icon target: full layout (HH + gap + dots + gap + MM) fills 80% of 1024px canvas.

let canvas: CGFloat = 1024

let appFont   = makeFont(96)
let appDigitW = measureWidth("10", font: appFont)
let appTotalW = 2 * appDigitW + 2 * 8 + 6 + 8  // two digit groups + two gaps + left pad + dot column

let scale    = (canvas * 0.80) / appTotalW
let fontSize = 96 * scale
let gap      =  8 * scale   // gap between digit group and dot column
let leftPad  =  6 * scale   // extra leading space before dot column (matches app padding)
let dotSize  =  8 * scale   // dot diameter
let dotGap   = 18 * scale   // gap between the two dots

// MARK: - Variants

struct Variant { let name, filename: String; let bg, fg, dot: UInt32 }

let variants: [Variant] = [
    Variant(name: "Light",  filename: "AppIcon-1024-light.png",
            bg: 0xFAFAFA, fg: 0x1A1A1A, dot: 0xFF6B35),
    Variant(name: "Dark",   filename: "AppIcon-1024-dark.png",
            bg: 0x0F0F0F, fg: 0xF5F5F5, dot: 0xFF6B35),
    Variant(name: "Tinted", filename: "AppIcon-1024-tinted.png",
            bg: 0xF0F0F0, fg: 0x505050, dot: 0x505050),
]

// MARK: - Render

func render(_ v: Variant, to url: URL) {
    let side = Int(canvas)
    guard let ctx = CGContext(
        data: nil, width: side, height: side,
        bitsPerComponent: 8, bytesPerRow: 0, space: deviceRGB,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else { fatalError("CGContext init failed for \(v.name)") }

    // Background
    ctx.setFillColor(cgColor(hex: v.bg))
    ctx.fill(CGRect(x: 0, y: 0, width: canvas, height: canvas))

    let font   = makeFont(fontSize)
    let digitW = measureWidth("10", font: font)

    // Vertical: center the ascent+descent band at canvas midpoint.
    // CG coordinate system has y=0 at the bottom.
    var asc: CGFloat = 0, desc: CGFloat = 0, lead: CGFloat = 0
    let probeLine: CTLine = {
        let ms = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)!
        CFAttributedStringReplaceString(ms, CFRangeMake(0, 0), "10" as CFString)
        CFAttributedStringSetAttribute(ms, CFRangeMake(0, 2), kCTFontAttributeName, font)
        return CTLineCreateWithAttributedString(ms)
    }()
    CTLineGetTypographicBounds(probeLine, &asc, &desc, &lead)
    let baseline = canvas / 2 - (asc - desc) / 2

    // Horizontal: center full layout
    let totalW = 2 * digitW + 2 * gap + leftPad + dotSize
    let x0 = (canvas - totalW) / 2

    // Build an attributed CTLine with font + foreground color
    func attrLine(_ text: String, color: CGColor) -> CTLine {
        let ms = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)!
        let len = CFStringGetLength(text as CFString)
        CFAttributedStringReplaceString(ms, CFRangeMake(0, 0), text as CFString)
        CFAttributedStringSetAttribute(ms, CFRangeMake(0, len), kCTFontAttributeName, font)
        CFAttributedStringSetAttribute(ms, CFRangeMake(0, len), kCTForegroundColorAttributeName, color)
        return CTLineCreateWithAttributedString(ms)
    }

    let fgColor = cgColor(hex: v.fg)

    // Hours "10"
    ctx.textPosition = CGPoint(x: x0, y: baseline)
    CTLineDraw(attrLine("10", color: fgColor), ctx)

    // Separator dots — two circles, vertically centered on canvas
    let dotX      = x0 + digitW + gap + leftPad
    let dotTotalH = 2 * dotSize + dotGap
    let dotY0     = canvas / 2 - dotTotalH / 2
    ctx.setFillColor(cgColor(hex: v.dot))
    ctx.fillEllipse(in: CGRect(x: dotX, y: dotY0,                    width: dotSize, height: dotSize))
    ctx.fillEllipse(in: CGRect(x: dotX, y: dotY0 + dotSize + dotGap, width: dotSize, height: dotSize))

    // Minutes "10"
    ctx.textPosition = CGPoint(x: dotX + dotSize + gap, y: baseline)
    CTLineDraw(attrLine("10", color: fgColor), ctx)

    // Export PNG
    guard let img  = ctx.makeImage(),
          let dest = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString, 1, nil)
    else { fatalError("Image export failed for \(v.name)") }
    CGImageDestinationAddImage(dest, img, nil)
    guard CGImageDestinationFinalize(dest) else { fatalError("Finalize failed for \(v.name)") }
    print("✓ \(v.name): \(url.lastPathComponent)")
}

// MARK: - Main

let scriptURL = URL(fileURLWithPath: CommandLine.arguments[0]).standardized
let repoRoot  = scriptURL.deletingLastPathComponent().deletingLastPathComponent()
let assetDir  = repoRoot
    .appendingPathComponent("SimpleClock")
    .appendingPathComponent("SimpleClock")
    .appendingPathComponent("Assets.xcassets")
    .appendingPathComponent("AppIcon.appiconset")

// Remove stale placeholder
let oldIcon = assetDir.appendingPathComponent("AppIcon-1024.png")
if FileManager.default.fileExists(atPath: oldIcon.path) {
    try FileManager.default.removeItem(at: oldIcon)
    print("Removed old placeholder: AppIcon-1024.png")
}

for v in variants {
    render(v, to: assetDir.appendingPathComponent(v.filename))
}
print("\nDone → \(assetDir.path)")
