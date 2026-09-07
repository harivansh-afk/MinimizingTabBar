import AppKit

// Original vector artwork for the video surround. All coordinates use a top-left origin.
let width = 1600, height = 1200
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: width * 4, bitsPerPixel: 32)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
let context = NSGraphicsContext.current!.cgContext
context.translateBy(x: 0, y: CGFloat(height))
context.scaleBy(x: 1, y: -1)
func rect(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ radius: CGFloat, _ color: NSColor) {
    context.setFillColor(color.cgColor)
    context.addPath(CGPath(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerWidth: radius, cornerHeight: radius, transform: nil))
    context.fillPath()
}
func text(_ value: String, _ x: CGFloat, _ y: CGFloat, size: CGFloat, color: NSColor, weight: NSFont.Weight = .regular, tracking: CGFloat = 0) {
    context.saveGState()
    context.translateBy(x: x, y: y)
    context.scaleBy(x: 1, y: -1)
    let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color, .kern: tracking]
    let string = NSAttributedString(string: value, attributes: attrs)
    string.draw(at: CGPoint(x: 0, y: -string.size().height))
    context.restoreGState()
}
let white = NSColor(calibratedWhite: 0.94, alpha: 1)
let muted = NSColor(calibratedWhite: 0.49, alpha: 1)
let green = NSColor(calibratedRed: 0.76, green: 0.86, blue: 0.58, alpha: 1)
rect(0, 0, 1600, 1200, 0, NSColor(calibratedRed: 0.065, green: 0.072, blue: 0.066, alpha: 1))
rect(110, 114, 30, 3, 1, green)
text("SWIFTUI  /  INTERACTION STUDY 01", 158, 105, size: 15, color: muted, weight: .medium, tracking: 2)
text("Minimizing", 106, 226, size: 80, color: white, weight: .medium, tracking: -3)
text("Tab Bar.", 106, 320, size: 80, color: white, weight: .medium, tracking: -3)
text("Follows your scroll.", 111, 469, size: 25, color: muted)
text("Returns with a touch.", 111, 507, size: 25, color: muted)
text("THE INTERACTION, UP CLOSE", 112, 704, size: 13, color: muted, weight: .medium, tracking: 2)
rect(105, 756, 773, 210, 28, NSColor(calibratedWhite: 0.13, alpha: 1))
rect(107, 758, 769, 206, 26, NSColor(calibratedRed: 0.045, green: 0.049, blue: 0.043, alpha: 1))
text("OPEN SOURCE", 112, 1060, size: 13, color: green, weight: .medium, tracking: 2)
text("Harivansh Rathi", 112, 1092, size: 19, color: white)
// Device surround. The actual simulator video is composited into this aperture.
context.saveGState()
context.setShadow(offset: CGSize(width: 0, height: 16), blur: 35, color: NSColor.black.withAlphaComponent(0.5).cgColor)
rect(969, 66, 496, 1068, 68, NSColor(calibratedWhite: 0.20, alpha: 1))
context.restoreGState()
rect(972, 69, 490, 1062, 65, NSColor(calibratedWhite: 0.055, alpha: 1))
NSGraphicsContext.restoreGraphicsState()
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "build/card.png"))

// Rounded alpha mask matching the scaled simulator screen.
let mw = 474, mh = 1030
let mask = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: mw, pixelsHigh: mh,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: mw * 4, bitsPerPixel: 32)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: mask)
NSColor.black.setFill()
NSBezierPath(rect: NSRect(x: 0, y: 0, width: mw, height: mh)).fill()
NSColor.white.setFill()
NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: mw, height: mh), xRadius: 56, yRadius: 56).fill()
NSGraphicsContext.restoreGraphicsState()
try mask.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "build/phone-mask.png"))
