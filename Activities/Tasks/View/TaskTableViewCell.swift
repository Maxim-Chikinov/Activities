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
    var color = Box(UIColor.systemBlue)
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
        lbl.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        return lbl
    }()
    
    private lazy var iconView: TaskIconView = {
        let view = TaskIconView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
            self?.iconView.icon = image
        }
        
        model.color.bind { [weak self] color in
            self?.iconView.color = color
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews(containerView)
        
        containerView.addSubviews(
            subtitleLabel,
            titleLabel,
            dateImageView, dateLabel,
            iconView,
            stateLabel
        )
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
            subtitleLabel.trailingAnchor == iconView.leadingAnchor - 16,
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor == subtitleLabel.bottomAnchor + 8,
            titleLabel.leadingAnchor == containerView.leadingAnchor + 16,
            titleLabel.trailingAnchor == iconView.leadingAnchor - 16
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
            iconView.topAnchor == containerView.topAnchor + 16,
            iconView.trailingAnchor == containerView.trailingAnchor - 16,
            iconView.widthAnchor == 30,
            iconView.heightAnchor == 30
        ])
    }
}

// MARK: - PreviewProvider
struct TaskTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        let cell = TaskTableViewCell()
        let model = TaskTableViewCellViewModel()
        model.title.value = "title"
        model.subtitle.value = "subtitle"
        model.state.value = "To-do"
        model.date.value = "13.02.2024 12:00"
        model.color.value = .brown
        cell.configure(model: model)
        
        return cell
            .showPreview()
            .frame(width: 380, height: 120)
            .padding(16)
    }
}
