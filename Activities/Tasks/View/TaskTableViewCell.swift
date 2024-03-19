//
//  TaskTableViewCell.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//


import UIKit
import SwiftUI

class TaskTableViewCellViewModel {
    var task = Task()
    
    var iconImage = Box(UIImage(named: "taskImg")?.withRenderingMode(.alwaysTemplate))
    var title = Box(String?(""))
    var subtitle = Box(String?(""))
    var date = Box(String?(""))
    var state = Box(String?(""))
}

class TaskTableViewCell: UITableViewCell {
    
    private(set) var model = TaskTableViewCellViewModel()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.roundCorners(16)
        view.addShadow(radius: 8)
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .black.withAlphaComponent(0.6)
        return lbl
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var dateImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "clock.fill")
        view.tintColor = UIColor(hexString: "AB94FF")
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = UIColor(hexString: "AB94FF")
        return lbl
    }()
    
    private lazy var stateLabel: PaddingLabel = {
        let lbl = PaddingLabel(insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = UIColor(hexString: "AB94FF")
        lbl.backgroundColor = UIColor(hexString: "E2F3FF")
        lbl.roundCorners(8)
        lbl.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return lbl
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "EDE4FF")
        view.roundCorners(6)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(hexString: "9260F4")
        return view
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
    
    func configure(model: TaskTableViewCellViewModel) {
        self.model = model
        
        model.subtitle.bind { [weak self] text in
            self?.subtitleLabel.text = text
        }
        
        model.title.bind { [weak self] text in
            self?.titleLabel.text = text
        }
        
        model.date.bind { [weak self] text in
            self?.dateLabel.text = text
        }
        
        model.state.bind { [weak self] text in
            self?.stateLabel.text = text
        }
        
        model.iconImage.bind { [weak self] image in
            self?.iconImageView.image = image
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews(containerView)
        
        containerView.addSubviews(
            subtitleLabel,
            titleLabel,
            dateImageView, dateLabel,
            imageContainer,
            stateLabel
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
            subtitleLabel.topAnchor == containerView.topAnchor + 18,
            subtitleLabel.leadingAnchor == containerView.leadingAnchor + 16,
            subtitleLabel.trailingAnchor == imageContainer.leadingAnchor - 16,
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor == subtitleLabel.bottomAnchor + 8,
            titleLabel.leadingAnchor == containerView.leadingAnchor + 16,
            titleLabel.trailingAnchor == imageContainer.leadingAnchor - 16
        ])
        
        NSLayoutConstraint.activate([
            dateImageView.centerYAnchor == dateLabel.centerYAnchor,
            dateImageView.leadingAnchor == containerView.leadingAnchor + 16,
            dateImageView.widthAnchor == 20
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor == titleLabel.bottomAnchor + 12,
            dateLabel.leadingAnchor == dateImageView.trailingAnchor + 8,
            dateLabel.trailingAnchor == stateLabel.leadingAnchor - 16,
            dateLabel.bottomAnchor <= containerView.bottomAnchor - 16
        ])
        
        NSLayoutConstraint.activate([
            stateLabel.trailingAnchor == containerView.trailingAnchor - 16,
            stateLabel.bottomAnchor == containerView.bottomAnchor - 16,
            stateLabel.widthAnchor <= 100
        ])
        
        NSLayoutConstraint.activate([
            imageContainer.topAnchor == containerView.topAnchor + 16,
            imageContainer.trailingAnchor == containerView.trailingAnchor - 16,
            imageContainer.widthAnchor == 30,
            imageContainer.heightAnchor == 30
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor == imageContainer.topAnchor + 4,
            iconImageView.leadingAnchor == imageContainer.leadingAnchor + 4,
            iconImageView.bottomAnchor == imageContainer.bottomAnchor - 4,
            iconImageView.trailingAnchor == imageContainer.trailingAnchor - 4
        ])
    }
}

// MARK: - PreviewProvider
struct TaskTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        let cell = TaskTableViewCell()
        let model = TaskTableViewCellViewModel()
        cell.configure(model: model)
        
        return cell
            .showPreview()
            .frame(width: 380, height: 120)
            .padding(16)
    }
}

