//
//  MainViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    private lazy var taskGroupsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var taskGroupsCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textAlignment = .center
        lbl.textColor = UIColor(hexString: "5F33E1")
        lbl.backgroundColor = UIColor(hexString: "EEE9FF")
        return lbl
    }()
    
    private let viewModel = MainViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBinding()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        taskGroupsCountLabel.roundCorners(taskGroupsCountLabel.frame.height / 2)
    }
    
    func setupBinding() {
        viewModel.taskGroupsTitle.bind { [weak self] text in
            self?.taskGroupsLabel.text = text
        }
        
        viewModel.taskGroupsCount.bind { [weak self] text in
            self?.taskGroupsCountLabel.text = text
        }
    }
    
    func setupSubviews() {
        view.addSubviews(
            taskGroupsLabel, taskGroupsCountLabel
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskGroupsLabel.topAnchor == view.safeAreaLayoutGuide.topAnchor + 16,
            taskGroupsLabel.leadingAnchor == view.leadingAnchor + 16
        ])
        
        NSLayoutConstraint.activate([
            taskGroupsCountLabel.centerYAnchor == taskGroupsLabel.centerYAnchor,
            taskGroupsCountLabel.leadingAnchor == taskGroupsLabel.trailingAnchor + 8,
            taskGroupsCountLabel.widthAnchor == taskGroupsCountLabel.heightAnchor,
            taskGroupsCountLabel.heightAnchor == taskGroupsLabel.heightAnchor
        ])
    }
}

// MARK: - PreviewProvider
struct MainViewControllerPreview: PreviewProvider {
    static var previews: some View {
        return MainViewController().toPreview()
    }
}
