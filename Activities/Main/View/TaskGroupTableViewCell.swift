//
//  TaskGroupTableViewCell.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit
import SwiftUI

class TaskGroupTableViewCellViewModel {
    var iconImage = Box(UIImage(named: "taskImg")?.withRenderingMode(.alwaysTemplate))
    var title = Box("Title")
    var subtitle = Box("Subtitle")
    var changeButtonAction: (() -> ())? = nil
    var selectButtonAction: (() -> ())? = nil
}

class TaskGroupTableViewCell: UITableViewCell {
    
    private(set) var model = TaskGroupTableViewCellViewModel()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.roundCorners(16)
        view.addShadow(radius: 8)
        return view
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "EDE4FF")
        view.roundCorners(12)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(hexString: "9260F4")
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .black.withAlphaComponent(0.6)
        return lbl
    }()
    
    private lazy var changeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(
            UIImage(named: "changeImg")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.backgroundColor = .black.withAlphaComponent(0.03)
        btn.tintColor = UIColor(hexString: "AB94FF")
        btn.roundCorners()
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: TaskGroupTableViewCellViewModel) {
        self.model = model
        
        model.iconImage.bind { [weak self] image in
            self?.iconImageView.image = image
        }
        
        model.title.bind { [weak self] text in
            self?.titleLabel.text = text
        }
        
        model.subtitle.bind { [weak self] text in
            self?.subtitleLabel.text = text
        }
        
        changeButton.addAction {
            model.changeButtonAction?()
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews(containerView)
        
        containerView.addSubviews(
            imageContainer,
            titleLabel,
            subtitleLabel,
            changeButton
        )
        
        imageContainer.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor == contentView.topAnchor + 8,
            containerView.leadingAnchor == contentView.leadingAnchor + 16,
            containerView.trailingAnchor == contentView.trailingAnchor - 16,
            containerView.bottomAnchor == contentView.bottomAnchor - 8
        ])
        
        NSLayoutConstraint.activate([
            imageContainer.topAnchor == containerView.topAnchor + 16,
            imageContainer.leadingAnchor == containerView.leadingAnchor + 24,
            imageContainer.bottomAnchor == containerView.bottomAnchor - 16,
            imageContainer.widthAnchor == imageContainer.heightAnchor
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor == imageContainer.topAnchor + 12,
            iconImageView.leadingAnchor == imageContainer.leadingAnchor + 12,
            iconImageView.bottomAnchor == imageContainer.bottomAnchor - 12,
            iconImageView.trailingAnchor == imageContainer.trailingAnchor - 12
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor == containerView.topAnchor + 22,
            titleLabel.leadingAnchor == imageContainer.trailingAnchor + 16,
            titleLabel.trailingAnchor == changeButton.leadingAnchor - 16
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor == titleLabel.bottomAnchor + 4,
            subtitleLabel.leadingAnchor == imageContainer.trailingAnchor + 16,
            subtitleLabel.trailingAnchor == changeButton.leadingAnchor - 16,
            subtitleLabel.bottomAnchor <= containerView.bottomAnchor - 16
        ])
        
        NSLayoutConstraint.activate([
            changeButton.widthAnchor == 32,
            changeButton.heightAnchor == 32,
            changeButton.centerYAnchor == containerView.centerYAnchor,
            changeButton.trailingAnchor == containerView.trailingAnchor - 24
        ])
    }
}

// MARK: - PreviewProvider
struct TaskGroupTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        let cell = TaskGroupTableViewCell()
        let model = TaskGroupTableViewCellViewModel()
        cell.configure(model: model)
        return cell
            .showPreview()
            .frame(width: 380, height: 100)
            .padding(16)
    }
}
