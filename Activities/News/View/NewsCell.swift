//
//  NewsCell.swift
//  Activities
//
//  Created by Chikinov Maxim on 12.04.2024.
//

import UIKit
import SwiftUI
import SnapKit
import Kingfisher

class NewsCellViewModel {
    var thumbnailImageView = Box("")
    var titleLabel = Box("")
    var dateLabel = Box("")
    var sourceLabel = Box("")
    
    init() {}
    
    init(currentPost post: NewsPosts) {
        thumbnailImageView.value = post.image ?? ""
        titleLabel.value = post.title ?? ""
        dateLabel.value = post.date?.iso8601Value()?.timeAgoSinceDate() ?? ""
        sourceLabel.value = post.source ?? ""
    }
}

class NewsCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(hexString: "EDE4FF")
        view.roundCorners(6)
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor(hexString: "EDD5FF")
        view.roundCorners(6)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .black.withAlphaComponent(0.6)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var sourceLabel: PaddingLabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: NewsCellViewModel) {
        model.thumbnailImageView.bind { [weak self] link in
            self?.iconImageView.kf.cancelDownloadTask()
            self?.iconImageView.kf.indicatorType = .activity
            self?.iconImageView.kf.setImage(with: URL(string: link))
        }
        
        model.titleLabel.bind { [weak self] text in
            self?.titleLabel.text = text
        }
        
        model.dateLabel.bind { [weak self] text in
            self?.dateLabel.text = text
        }
        
        model.sourceLabel.bind { [weak self] text in
            self?.sourceLabel.text = text
        }
    }
    
    private func setupSubviews() {
        contentView.addSubviews(
            containerView
        )
        
        containerView.addSubviews(
            iconImageView,
            titleLabel,
            dateLabel,
            sourceLabel
        )
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(0)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.equalTo(iconImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalTo(iconImageView.snp.right).inset(-16)
            make.right.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.equalTo(iconImageView.snp.right).inset(-16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.left.equalTo(dateLabel.snp.right).inset(0)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
    }
}

// MARK: - PreviewProvider
struct NewsCellPreview: PreviewProvider {
    static var previews: some View {
        let cell = NewsCell()
        let model = NewsCellViewModel()
        model.titleLabel.value = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        model.dateLabel.value = "• one minute ago"
        model.sourceLabel.value = "www.bbc.com"
        cell.configure(model: model)
        
        return cell
            .showPreview()
            .frame(width: 380, height: 150)
            .padding(16)
    }
}
