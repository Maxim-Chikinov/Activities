//
//  UIStackView+Extension.swift
//  QuickLayouts
//
//  Created by Chikinov Maxim on 14.09.2023.
//

import UIKit

extension UIStackView {
    
    // MARK: - Methods
    func removeAllArrangedSubviews() {
        for subView in arrangedSubviews {
            removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
}
