//
//  TaskIconView.swift
//  Activities
//
//  Created by Chikinov Maxim on 21.03.2024.
//

import UIKit
import SnapKit
import SwiftUI

class TaskIconView: UIButton {
    
    var color: UIColor? {
        didSet {
            imageContainer.backgroundColor = color?.withAlphaComponent(0.2)
            iconImageView.tintColor = color
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon?.template
        }
    }
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(hexString: "EDE4FF")
        view.roundCorners(6)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(imageContainer)
        imageContainer.addSubviews(iconImageView)
        
        imageContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PreviewProvider
struct TaskIconViewPreview: PreviewProvider {
    static var previews: some View {
        let view = TaskIconView()
        view.color = .red
        view.icon = UIImage(named: "taskImg")?.template
        
        return view
            .showPreview()
            .frame(width: 30, height: 30)
            .padding(16)
    }
}
