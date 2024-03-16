//
//  RoundedContainerView.swift
//  QuickLayouts
//
//  Created by Chikinov Maxim on 18.09.2023.
//

import UIKit
import EasyPeasy

class RoundedContainerView: BorderedGradientView {
    
    struct ColorViewModel {
        enum ColorMode {
            case simple(UIColor)
            case gradient(UIColor, UIColor)
        }
        
        var colorMode: ColorMode
        var borderColors: [UIColor] = []
    }
    
    var colorViewModel: ColorViewModel {
        didSet {
            setupColor()
        }
    }
    
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let cornerRaduis: CGFloat

    private lazy var horizontalContainerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = horizontalSpacing
        return stack
    }()

    private lazy var verticalContainerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = verticalSpacing
        return stack
    }()

    init(
        cornerRaduis: CGFloat = 26.0,
        colorViewModel: ColorViewModel,
        insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 15, bottom: 16, right: 16),
        horizontalSpacing: CGFloat = 2,
        verticalSpacing: CGFloat = 2
    ) {
        self.cornerRaduis = cornerRaduis
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.colorViewModel = colorViewModel
        super.init(frame: .zero)
        
        applyCornerRadius(cornerRaduis)
        
        addSubview(horizontalContainerStackView)
        horizontalContainerStackView.easy.layout(
            Top(insets.top),
            Leading(insets.left), Trailing(insets.right),
            Bottom(insets.bottom)
        )

        horizontalContainerStackView.addArrangedSubview(verticalContainerStackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupColor()
    }
    
    func setCustomHorizontalSpacing(_ spacing: CGFloat, after view: UIView) {
        horizontalContainerStackView.setCustomSpacing(spacing, after: view)
    }
    
    func setCustomVerticalSpacing(_ spacing: CGFloat, after view: UIView) {
        verticalContainerStackView.setCustomSpacing(spacing, after: view)
    }
    
    func setupColor() {
        switch colorViewModel.colorMode {
        case .simple(let color):
            backgroundColor = color
        case let .gradient(first, second):
            applyGradients(
                backgroundColors: [first, second],
                fromPointBackground: CGPoint(x: 0.5, y: 0), toPointBackground: CGPoint(x: 0.5, y: 1),
                borderColors: colorViewModel.borderColors,
                fromPointBorder: CGPoint(x: 0.5, y: 0), toPointBorder: CGPoint(x: 0.5, y: 1),
                borderWidth: 1
            )
        }
    }
    
    func addViewToBottom(_ view: UIView) {
        verticalContainerStackView.addArrangedSubview(view)
    }
    
    func addSpaceToBottom(_ space: CGFloat, after view: UIView) {
        verticalContainerStackView.setCustomSpacing(space, after: view)
    }

    func addViewToRight(_ view: UIView) {
        horizontalContainerStackView.addArrangedSubview(view)
    }
    
    func removeAllSubviewsFromHorizontalStackView() {
        horizontalContainerStackView.removeAllArrangedSubviews()
    }
    
    func removeAllSubviewsFromVerticalStackView() {
        verticalContainerStackView.removeAllArrangedSubviews()
    }
}

