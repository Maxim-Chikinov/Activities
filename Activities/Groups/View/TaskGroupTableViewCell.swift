//
//  TaskGroupTableViewCell.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit
import SwiftUI

class GroupTableViewCellViewModel {
    var group = Group()
    
    var iconImage = Box(UIImage(systemName: "folder.fill")?.withRenderingMode(.alwaysTemplate))
    var color = Box(UIColor.systemBlue)
    var title = Box("Title")
    var subtitle = Box("Subtitle")
}

class TaskGroupTableViewCell: UITableViewCell {
    
    private(set) var model = GroupTableViewCellViewModel()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.roundCorners(16)
        view.addShadow(radius: 8)
        return view
    }()
    
    private lazy var iconView: TaskIconView = {
        let view = TaskIconView()
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
        lbl.numberOfLines = 0
        return lbl
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
    
    func configure(model: GroupTableViewCellViewModel) {
        self.model = model
        
        model.iconImage.bind { [weak self] image in
            self?.iconView.icon = image
        }
        
        model.title.bind { [weak self] text in
            self?.titleLabel.text = text
        }
        
        model.subtitle.bind { [weak self] text in
            self?.subtitleLabel.text = text
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews(containerView)
        
        containerView.addSubviews(
            iconView,
            titleLabel,
            subtitleLabel
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor == contentView.topAnchor + 8,
            containerView.leadingAnchor == contentView.leadingAnchor + 16,
            containerView.trailingAnchor == contentView.trailingAnchor - 16,
            containerView.bottomAnchor == contentView.bottomAnchor - 8
        ])
        
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalTo(containerView).offset(16)
            make.centerY.equalTo(containerView)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor == containerView.topAnchor + 22,
            titleLabel.leadingAnchor == iconView.trailingAnchor + 16,
            titleLabel.trailingAnchor == containerView.trailingAnchor - 16
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor == titleLabel.bottomAnchor + 4,
            subtitleLabel.leadingAnchor == iconView.trailingAnchor + 16,
            subtitleLabel.trailingAnchor == containerView.trailingAnchor - 16,
            subtitleLabel.bottomAnchor <= containerView.bottomAnchor - 16
        ])
    }
}

// MARK: - PreviewProvider
struct TaskGroupTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        let cell = TaskGroupTableViewCell()
        let model = GroupTableViewCellViewModel()
        model.subtitle.value = "The sdf dksfjj flkdsjf s dl;fkjsdf jsdklfj"
        cell.configure(model: model)
        return cell
            .showPreview()
            .frame(width: 380, height: 100)
            .padding(16)
    }
}
