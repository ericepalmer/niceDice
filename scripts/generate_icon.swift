#!/usr/bin/env swift
import AppKit

let sizes: [CGFloat] = [16, 32, 64, 128, 256, 512, 1024]
let outDir = URL(fileURLWithPath: CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "NiceDice/Assets.xcassets/AppIcon.appiconset")

func drawIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    let rect = NSRect(x: 0, y: 0, width: size, height: size)
    let radius = size * 0.22
    let rounded = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)

    NSColor(calibratedRed: 0.09, green: 0.16, blue: 0.12, alpha: 1).setFill()
    rounded.fill()

    let bag = NSBezierPath()
    let w = size
    let h = size
    let neckY = h * 0.62
    let cx = w * 0.5
    bag.move(to: NSPoint(x: cx - w * 0.16, y: neckY))
    bag.curve(
        to: NSPoint(x: w * 0.18, y: h * 0.38),
        controlPoint1: NSPoint(x: w * 0.22, y: neckY - 2),
        controlPoint2: NSPoint(x: w * 0.12, y: h * 0.50)
    )
    bag.curve(
        to: NSPoint(x: cx, y: h * 0.12),
        controlPoint1: NSPoint(x: w * 0.12, y: h * 0.24),
        controlPoint2: NSPoint(x: w * 0.28, y: h * 0.13)
    )
    bag.curve(
        to: NSPoint(x: w * 0.82, y: h * 0.38),
        controlPoint1: NSPoint(x: w * 0.72, y: h * 0.13),
        controlPoint2: NSPoint(x: w * 0.88, y: h * 0.24)
    )
    bag.curve(
        to: NSPoint(x: cx + w * 0.16, y: neckY),
        controlPoint1: NSPoint(x: w * 0.88, y: h * 0.50),
        controlPoint2: NSPoint(x: w * 0.78, y: neckY - 2)
    )
    bag.close()

    NSColor(calibratedRed: 0.55, green: 0.34, blue: 0.18, alpha: 1).setFill()
    bag.fill()

    let pip = NSBezierPath(ovalIn: NSRect(
        x: cx - size * 0.11,
        y: h * 0.30,
        width: size * 0.22,
        height: size * 0.22
    ))
    NSColor(calibratedRed: 0.93, green: 0.78, blue: 0.30, alpha: 1).setFill()
    pip.fill()

    image.unlockFocus()
    return image
}

try FileManager.default.createDirectory(at: outDir, withIntermediateDirectories: true)

for size in sizes {
    let image = drawIcon(size: size)
    guard let tiff = image.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:]) else {
        fatalError("Failed to encode icon \(Int(size))")
    }
    let url = outDir.appendingPathComponent("icon_\(Int(size)).png")
    try png.write(to: url)
    print("Wrote \(url.path)")
}
