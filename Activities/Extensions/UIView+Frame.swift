//
//  UIView+Frame.swift
//  QuickLayouts
//
//  Created by Chikinov Maxim on 13.09.2023.
//

import UIKit

extension UIView {
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            var origin = frame.origin
            origin.y = newValue
            frame.origin = origin
            self.frame = frame
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            var origin = frame.origin
            origin.x = newValue
            frame.origin = origin
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            var size = frame.size
            size.width = newValue
            frame.size = size
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            var size = frame.size
            size.height = newValue
            frame.size = size
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            self.left = newValue - self.width
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.maxY
        }
        set {
            self.top = newValue - height
        }
    }
    
    func border(_ color: UIColor = UIColor.black, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func removeBorder() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
    func removeRoundedCorners() {
        layer.masksToBounds = false
        layer.cornerRadius = 0
        layer.mask = nil
    }
    
    func roundCorners(_ radius: CGFloat = 8.0) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.mask = nil
        
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
    
    func roundCorners(_ radius: CGFloat = 8.0, corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.masksToBounds = true
        layer.cornerRadius = 0
        layer.mask = shape
    }
    
    func roundCorners(_ radius: CGFloat = 8.0, size: CGSize, corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.masksToBounds = true
        layer.mask = shape
    }
    
    func maskCorners(radius: CGFloat, _ corners: UIRectCorner = .allCorners) {
        var cornerMasks = CACornerMask()
        if corners.contains(.allCorners) {
            cornerMasks.insert(.layerMinXMinYCorner)
            cornerMasks.insert(.layerMaxXMinYCorner)
            cornerMasks.insert(.layerMinXMaxYCorner)
            cornerMasks.insert(.layerMaxXMaxYCorner)
        }
        if corners.contains(.topLeft) {
            cornerMasks.insert(.layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
            cornerMasks.insert(.layerMaxXMinYCorner)
        }
        if corners.contains(.bottomLeft) {
            cornerMasks.insert(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
            cornerMasks.insert(.layerMaxXMaxYCorner)
        }
        
        layer.maskedCorners = cornerMasks
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func addGradient(fromColor: UIColor, toColor: UIColor, fromPoint: CGPoint, toPoint: CGPoint) {
        backgroundColor = UIColor.clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = fromPoint
        gradientLayer.endPoint = toPoint
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        if layer.sublayers?.last is CAGradientLayer {
            layer.sublayers?.removeLast()
        }
        layer.addSublayer(gradientLayer)
    }
    
    func addGradient(colors: [UIColor], locations: [NSNumber], from: CGPoint, to: CGPoint) {
        guard colors.count > 1 else {
            return
        }
        guard locations.count == colors.count else {
            return
        }
        
        backgroundColor = UIColor.clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = from
        gradientLayer.endPoint = to
        gradientLayer.colors = colors.map({ $0.cgColor })
        gradientLayer.locations = locations
        if layer.sublayers?.last is CAGradientLayer {
            layer.sublayers?.removeLast()
        }
        layer.addSublayer(gradientLayer)
    }
    
    func updateHeightToFitSubviews(spacing: CGFloat = 0) {
        guard !subviews.isEmpty else {
            return
        }
        height = subviews.sorted(by: { $0.bottom > $1.bottom }).first!.bottom + spacing
    }
    
    func fixArtefact() {
        let roundWidth = Int(self.width)
        if roundWidth % 2 != 0 {
            self.width = CGFloat(roundWidth) + 1 /// Add one
        } else {
            self.width = CGFloat(roundWidth) + 2 /// Fix "..."
        }
    }
    
    var isRectValid: Bool {
        if self.bounds.isNull || self.bounds.isInfinite {
            return false
        } else {
            return true
        }
    }
    
    /**
     Apply gradient to UIView
     If you applied this method on view, where there is last sublayer of type CAGradientLayer, it will be overwrited
     
     - Parameter withFrame: This parameter is optional, by default uses bounds of self
     - Parameter alpha: This parameter is optional, maximum alpha of black that will reach on view, by default uses alpha = 0.6
     */
    func addGradient(withFrame frame: CGRect? = nil, alpha: CGFloat = 0.6) {
        let gradientLayer = CAGradientLayer()
        backgroundColor = UIColor.clear
        if let rect = frame {
            gradientLayer.frame = rect
        } else {
            gradientLayer.frame = self.bounds
        }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        let color0 = UIColor(white: 0, alpha: 0.0).cgColor as CGColor
        let colormiddle = UIColor(white: 0, alpha: alpha/3).cgColor as CGColor
        let color1 = UIColor(white: 0, alpha: alpha).cgColor as CGColor
        gradientLayer.colors = [color0, colormiddle, color1]
        gradientLayer.locations = [0.0,0.5,1.0]
        if layer.sublayers?.last is CAGradientLayer {
            layer.sublayers?.removeLast()
        }
        layer.addSublayer(gradientLayer)
    }
    
    // Radial Gradient View
    func applyRadialGradient(colors: [UIColor], locations: [CGFloat], manualBounds: CGRect? = nil) {
        let gradientLayer = RadialGradientLayer()
        gradientLayer.frame = manualBounds ?? bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradientBorder(
        colors: [CGColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 1, y: 0),
        lineWidth: CGFloat = 2
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: layer.cornerRadius
        ).cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    func applyBlur(style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func fadeIn(duration: Double, andDelay delay: Double = 0, completion: (() -> Void)? = nil) {
        self.fade(fromAlpha: 0, toAlpha: 1, duration: duration, andDelay: delay, completion: completion)
    }
    
    func fadeOut(duration: Double, andDelay delay: Double = 0, completion: (() -> Void)? = nil) {
        self.fade(fromAlpha: 1, toAlpha: 0, duration: duration, andDelay: delay, completion: completion)
    }
    
    func fade(fromAlpha: CGFloat, toAlpha: CGFloat, duration: Double, andDelay delay: Double = 0, completion: (() -> Void)? = nil) {
        self.alpha = fromAlpha
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: { [weak self] in
            self?.alpha = toAlpha
        }) { [weak self] _ in
            self?.alpha = toAlpha
            completion?()
        }
    }
    
    func layoutSubviewsAnimated(duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        })
    }
}

class RadialGradientLayer: CALayer {
    var colors: [CGColor] = []
    var locations: [CGFloat] = [0.0, 1.0]
    
    override init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: locations
        ) else { return }
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        
        ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: [])
    }
}

extension UIView {
    func startZooming(from: Double = 1, to: Double = 0.9, duration: Double = 2, loop: Bool = true) {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.duration = duration
        scale.fromValue = from
        scale.toValue = to
        scale.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        scale.autoreverses = loop
        scale.repeatCount = loop ? .infinity : 0
        scale.fillMode = loop ? .removed : .forwards
        scale.isRemovedOnCompletion = loop ? true : false
        
        self.layer.add(scale, forKey: "scale")
    }
    
    func stopZooming() {
        self.layer.removeAnimation(forKey: "scale")
    }
}

extension UILabel {
    @discardableResult
    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {

        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0

        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }

        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0

        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }

        let gradientText = self.text ?? ""

        let name = NSAttributedString.Key.font
        let textSize: CGSize = gradientText.size(withAttributes: [name : self.font!])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height

        UIGraphicsBeginImageContext(CGSize(width: width, height: height))

        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsPushContext(context)

        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)

        UIGraphicsPopContext()

        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }

        UIGraphicsEndImageContext()

        self.textColor = UIColor(patternImage: gradientImage)

        return true
    }

}
