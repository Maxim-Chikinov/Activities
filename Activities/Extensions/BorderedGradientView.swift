//
//  BorderedGradientView.swift
//  QuickLayouts
//
//  Created by Chikinov Maxim on 18.09.2023.
//

import UIKit

class BorderedGradientView: CustomViewBase {
    private let backgroundGradient = CAGradientLayer()
    private let borderGradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradients()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradients()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = bounds
        borderGradient.frame = bounds
    }
    
    private func setupGradients() {
        
        layer.insertSublayer(backgroundGradient, at: 0)
        layer.insertSublayer(borderGradient, at: 0)
    }
    
    func applyCornerRadius(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        backgroundGradient.cornerRadius = layer.cornerRadius
        borderGradient.cornerRadius = layer.cornerRadius
    }
    
    func applyGradient(colors: [UIColor], fromPoint: CGPoint, toPoint: CGPoint) {
        backgroundGradient.frame = bounds
        backgroundGradient.colors = colors.map { $0.cgColor }
        backgroundGradient.startPoint = fromPoint
        backgroundGradient.endPoint = toPoint
    }
    
    func applyBorderGradient(colors: [UIColor], fromPoint: CGPoint, toPoint: CGPoint, borderWidth: CGFloat) {
        borderGradient.frame = bounds
        borderGradient.colors = colors.map { $0.cgColor }
        borderGradient.startPoint = fromPoint
        borderGradient.endPoint = toPoint
        borderGradient.borderWidth = borderWidth
    }
    
    func applyGradients(backgroundColors: [UIColor], fromPointBackground: CGPoint, toPointBackground: CGPoint, borderColors: [UIColor], fromPointBorder: CGPoint, toPointBorder: CGPoint, borderWidth: CGFloat) {
        let backgroundBounds = CGRect(x: bounds.minX + borderWidth,
                                      y: bounds.minY + borderWidth,
                                      width: bounds.width - borderWidth * 2,
                                      height: bounds.height - borderWidth * 2)
        
        backgroundGradient.frame = backgroundBounds
        backgroundGradient.colors = backgroundColors.map { $0.cgColor }
        backgroundGradient.startPoint = fromPointBackground
        backgroundGradient.endPoint = toPointBackground
        
        borderGradient.frame = bounds
        borderGradient.colors = borderColors.map { $0.cgColor }
        borderGradient.startPoint = fromPointBorder
        borderGradient.endPoint = toPointBorder
    }
}

class CustomViewBase: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.completeInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.completeInit()
    }
    
    func completeInit() {
    }
}
