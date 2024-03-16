////
////  ProcessingButton.swift
////  Winline
////
////  Created by Chikinov Maxim on 18.08.2022.
////  Copyright © 2022 Grow App. All rights reserved.
////
//
//import UIKit
//import EasyPeasy
//
/////
///// Button class for uniform action button design throughout the application.
///// More informations in:
///// https://app.zeplin.io/project/5fb533e91345e372c2ed9aed/screen/62f4b7564fcf678578874a9d
/////
//final class ProcessingButton: UIButton {
//    
//    ///
//    /// Button design types
//    ///
//    enum State: Equatable {
//        case standBy
//        case secondary
//        case disable
//        case processing
//        case success(animated: Bool)
//        
//        static func == (lhs: State, rhs: State) -> Bool {
//            switch (lhs, rhs) {
//            case (.standBy, .standBy):
//                return true
//            case (.secondary, .secondary):
//                return true
//            case (.disable, .disable):
//                return true
//            case (.processing, .processing):
//                return true
//            case (.success(_), .success(_)):
//                return true
//            default:
//                return false
//            }
//        }
//    }
//    
//    //MARK: - Public properties
//    var mode: State = .standBy {
//        didSet {
//            switch mode {
//            
//            // Default style of the button
//            // The background is completely painted over, there is no border, the text of the button is white
//            case .standBy:
//                isEnabled = true
//                backgroundColor = _color
//                leftImage.isHidden = true
//                label.textColor = .white
//                removeBorder()
//                setImage(nil, for: .normal)
//                stopLoadAnimation()
//                
//            // Additional style of the button
//            // The background is white, there is border, the color of border and text like properties color
//            case .secondary:
//                isEnabled = true
//                backgroundColor = .clear
//                leftImage.isHidden = true
//                label.textColor = _color
//                border(_color ?? .clear, width: 1)
//                stopLoadAnimation()
//            
//            // Disable style
//            // Color of button is dim(alpha is 0.32), button not enable
//            case .disable:
//                isEnabled = false
//                backgroundColor = _color?.withAlphaComponent(0.32)
//                leftImage.isHidden = true
//                label.textColor = _color?.withAlphaComponent(0.6)
//                removeBorder()
//                stopLoadAnimation()
//            
//            // Load style
//            // Looks like Default style, but with load animation and without title
//            // Button is disable
//            case .processing:
//                isEnabled = false
//                backgroundColor = _color
//                leftImage.isHidden = true
//                label.textColor = .white
//                removeBorder()
//                startLoadAnimation()
//            
//            // Processing success style
//            // Looks like Additional style, but with left check mark image
//            case .success(let animated):
//                isEnabled = true
//                backgroundColor = .clear
//                border(_color ?? .clear, width: 2)
//                stopLoadAnimation()
//                
//                label.textColor = _color
//                
//                let image = UIImage(named: "success.icon")
//                leftImage.image = image
//                
//                if !animated {
//                    leftImage.isHidden = false
//                } else {
//                    leftImage.alpha = 0
//                    leftImage.isHidden = false
//                    UIView.animate(withDuration: 0.2) {
//                        self.leftImage.alpha = 1
//                    }
//                }
//            }
//        }
//    }
//    
//    ///
//    /// Title of button with observer and set function
//    ///
//    var title: String? {
//        didSet {
//            label.text = title
//        }
//    }
//    
//    ///
//    /// Color of background or border and text(depends on the current state) with observer and set function
//    ///
//    var color: UIColor = .clear {
//        didSet {
//            _color = color
//        }
//    }
//    
//    ///
//    /// Color of background or border and text(depends on the current state) with observer and set function
//    ///
//    var numberOfLabelLines: Int = 1 {
//        didSet {
//            label.numberOfLines = numberOfLabelLines
//        }
//    }
//    
//    ///
//    /// Round all corners of button
//    ///
//    var roundCorners: CGFloat? = nil {
//        didSet {
//            layoutSubviews()
//        }
//    }
//    
//    //MARK: - Private properties
//    private var _titleColor: UIColor? = .white
//    private var _color: UIColor? = .brandGreen
//    private let _touchDownAlpha: CGFloat = 0.8
//    private var _isLoading = false
//    
//    //MARK: - Views
//    private lazy var stackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 11
//        stack.isUserInteractionEnabled = false
//        
//        return stack
//    }()
//    
//    private lazy var label: UILabel = {
//        let lbl = UILabel()
//        lbl.font = .sfProDisplayMedium(size: 16)
//        lbl.textColor = .white
//        lbl.textAlignment = .center
//        
//        return lbl
//    }()
//    
//    private lazy var leftImage: UIImageView = {
//        let view = UIImageView()
//        view.contentMode = .scaleAspectFit
//        
//        return view
//    }()
//    
//    private lazy var loadImage: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "loadIcon")?.withRenderingMode(.alwaysTemplate)
//        view.tintColor = .white
//        view.contentMode = .scaleAspectFit
//        view.alpha = 0
//        
//        return view
//    }()
//    
//    //MARK: - Init and setup view
//    convenience init() {
//        self.init(type: .custom)
//        
//        clipsToBounds = true
//        
//        addSubviews(stackView)
//        
//        stackView.addArrangedSubview(leftImage)
//        stackView.addArrangedSubview(label)
//        
//        stackView.easy.layout(
//            Top(5),
//            Leading(>=5),
//            Trailing(<=5),
//            Bottom(5),
//            CenterX()
//        )
//    }
//    
//    //MARK: - Override functions
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        guard let round = roundCorners else {
//            roundCorners(height / 2)
//            return
//        }
//        
//        roundCorners(round)
//    }
//    
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted {
//                touchDown()
//            } else {
//                touchUp()
//            }
//        }
//    }
//    
//    func setFont(_ font: UIFont) {
//        label.font = font
//    }
//    
//    // MARK: - Private functions
//    
//    ///
//    /// Start load animation for processing style
//    ///
//    private func startLoadAnimation() {
//        guard !_isLoading else {
//            return
//        }
//        _isLoading = true
//        
//        if self.loadImage.superview == nil {
//            addSubview(loadImage)
//            loadImage.easy.layout(
//                CenterX(),
//                CenterY(),
//                Width(22),
//                Height(22)
//            )
//        }
//        
//        loadImage.fadeIn()
//        loadImage.rotate()
//        label.fadeOut(duration: 0.1)
//    }
//    
//    ///
//    /// Stop load animation for processing style
//    ///
//    private func stopLoadAnimation() {
//        guard _isLoading else {
//            return
//        }
//        _isLoading = false
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
//            guard let self = self else { return }
//            
//            self.loadImage.fadeOut()
//            self.loadImage.stopRotating()
//            self.label.fadeIn(duration: 0.1)
//        }
//    }
//    
//    // Animations of button
//    private func touchDown() {
//        UIView.animate(withDuration: 0.1) {
//            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
//            self.alpha = self._touchDownAlpha
//        }
//    }
//    
//    private func touchUp() {
//        UIView.animate(withDuration: 0.1) {
//            self.transform = CGAffineTransform(scaleX: 1, y: 1)
//            self.alpha = 1
//        }
//    }
//}
