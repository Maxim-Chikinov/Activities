//
//  Stack.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import UIKit

final class Stack: UIView {
    
    var axis: NSLayoutConstraint.Axis = .vertical
    var margins: UIEdgeInsets = .zero
    var spacing: CGFloat = 0
    var views: [UIView] = []
    var isScrollabel = false
    var indicatorStyle: UIScrollView.IndicatorStyle = .black
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        switch axis {
        case .horizontal:
            scroll.alwaysBounceHorizontal = true
        case .vertical:
            scroll.alwaysBounceVertical = true
        default:
            break
        }
        scroll.indicatorStyle = indicatorStyle
        return scroll
    }()
    
    private lazy var scrollContentView = UIView()
    
    init(
        axis: NSLayoutConstraint.Axis,
        margins: UIEdgeInsets,
        spacing: CGFloat,
        views: [UIView] = [],
        isScrollabel: Bool = false,
        indicatorStyle: UIScrollView.IndicatorStyle = .black
    ) {
        self.axis = axis
        self.margins = margins
        self.spacing = spacing
        self.views = views
        self.isScrollabel = isScrollabel
        self.indicatorStyle = indicatorStyle
        
        super.init(frame: .zero)
        clipsToBounds = true
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
        addViews(views)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(_ views: [UIView]) {
        mainStackView.removeAllArrangedSubviews()
        views.forEach { view in
            mainStackView.addArrangedSubview(view)
        }
    }
    
    func addPadding(_ spacing: CGFloat, after view: UIView) {
        mainStackView.setCustomSpacing(spacing, after: view)
    }
    
    private func setupViews() {
        if isScrollabel {
            addSubviews(scrollView)
            scrollView.addSubview(scrollContentView)
            scrollContentView.addSubview(mainStackView)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor == topAnchor,
                scrollView.leadingAnchor == leadingAnchor,
                scrollView.trailingAnchor == trailingAnchor,
                scrollView.bottomAnchor == bottomAnchor
            ])
            
            NSLayoutConstraint.activate([
                scrollContentView.topAnchor == scrollView.topAnchor,
                scrollContentView.bottomAnchor == scrollView.bottomAnchor,
                scrollContentView.widthAnchor == scrollView.widthAnchor,
                scrollContentView.centerXAnchor == scrollView.centerXAnchor,
            ])
            
            NSLayoutConstraint.activate([
                mainStackView.topAnchor == scrollContentView.topAnchor + margins.top,
                mainStackView.leadingAnchor == scrollContentView.leadingAnchor + margins.left,
                mainStackView.trailingAnchor == scrollContentView.trailingAnchor - margins.right,
                mainStackView.bottomAnchor == scrollContentView.bottomAnchor - margins.bottom
            ])
        } else {
            addSubviews(mainStackView)
            
            NSLayoutConstraint.activate([
                mainStackView.topAnchor == topAnchor + margins.top,
                mainStackView.leadingAnchor == leadingAnchor + margins.left,
                mainStackView.trailingAnchor == trailingAnchor - margins.right,
                mainStackView.bottomAnchor == bottomAnchor - margins.bottom
            ])
        }
    }
}
