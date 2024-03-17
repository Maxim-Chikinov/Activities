//
//  CustomSegmentedControl.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        baseInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // The system displays an image view for each segment that is a gray color - hide it to reveal the intended background color
        let imageViews = subviews.compactMap { $0 as? UIImageView }.prefix(numberOfSegments)
        imageViews.forEach { $0.isHidden = true }
    }
    
    private func baseInit() {
        backgroundColor = .white
        selectedSegmentTintColor = .systemFill
    }

}
