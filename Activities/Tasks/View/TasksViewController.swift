//
//  TasksViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit
import SwiftUI

class TasksViewController: UIViewController {
    
    var viewModel: TasksViewControllerViewModel
    
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
        lbl.textColor = UIColor(hexString: "5F33E1")
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(hexString: "EEE9FF")
        return lbl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.separatorColor = .clear
        tableView.register(cellType: TaskTableViewCell.self)
        return tableView
    }()
    
    init(viewModel: TasksViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Tasks Screen"
        
        setupBinding()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getData()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        taskGroupsCountLabel.roundCorners(taskGroupsCountLabel.frame.height / 2)
    }
    
    private func setupBinding() {
        viewModel.taskTitle.bind { [weak self] text in
            self?.taskGroupsLabel.text = text
        }
        
        viewModel.taskCount.bind { [weak self] text in
            self?.taskGroupsCountLabel.text = text
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(
            taskGroupsLabel, taskGroupsCountLabel,
            tableView
        )
    }
    
    private func setupConstraints() {
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor == taskGroupsLabel.bottomAnchor + 8,
            tableView.leadingAnchor == view.leadingAnchor,
            tableView.trailingAnchor == view.trailingAnchor,
            tableView.bottomAnchor == view.bottomAnchor
        ])
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID) as! TaskTableViewCell
        let model = viewModel.tasks[indexPath.row]
        cell.configure(model: model)
        return cell
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.tasks[indexPath.row]
        model.selectButtonAction?()
    }
}

// MARK: - PreviewProvider
struct TasksViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let coordinator = TasksScreenCoordinator(
            navigationController: UINavigationController(),
            tabBar: UITabBarController()
        )
        
        let model = TasksViewControllerViewModel()
        model.coordinator = coordinator
        let vc = TasksViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
