//
//  GroupsViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit
import SwiftUI
import SnapKit

class GroupsViewController: UIViewController {
    
    var viewModel: GroupsViewControllerViewModel
    
    private lazy var taskGroupsLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .black
        return lbl
    }()
    
    private lazy var groupsCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = UIColor(hexString: "5F33E1")
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(hexString: "EEE9FF")
        return lbl
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(
            UIImage(systemName: "plus.rectangle.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.tintColor = UIColor(hexString: "5F33E1")
        btn.setTitle("Add ", for: .normal)
        btn.roundCorners()
        btn.semanticContentAttribute = .forceRightToLeft
        btn.addAction { [weak self] in
            self?.viewModel.openAddTasks()
        }
        return btn
    }()
    
    private lazy var editButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(
            UIImage(named: "editImg")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.tintColor = UIColor(hexString: "5F33E1")
        btn.setTitle("Edit ", for: .normal)
        btn.roundCorners()
        btn.semanticContentAttribute = .forceRightToLeft
        btn.addAction { [weak self] in
            
        }
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.separatorColor = .clear
        tableView.register(cellType: GroupTableViewCell.self)
        return tableView
    }()
    
    init(viewModel: GroupsViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(Self.description()): deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Groups"
        
        setupBinding()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        groupsCountLabel.roundCorners(groupsCountLabel.frame.height / 2)
    }
    
    private func setupBinding() {
        viewModel.taskGroupsTitle.bind { [weak self] text in
            self?.taskGroupsLabel.text = text
        }
        
        viewModel.taskGroupsCount.bind { [weak self] text in
            self?.groupsCountLabel.text = text
        }
        
        viewModel.onGroupsUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(
            taskGroupsLabel, groupsCountLabel, addButton, editButton,
            tableView
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskGroupsLabel.topAnchor == view.safeAreaLayoutGuide.topAnchor + 16,
            taskGroupsLabel.leadingAnchor == view.leadingAnchor + 16
        ])
        
        NSLayoutConstraint.activate([
            groupsCountLabel.centerYAnchor == taskGroupsLabel.centerYAnchor,
            groupsCountLabel.leadingAnchor == taskGroupsLabel.trailingAnchor + 8,
            groupsCountLabel.widthAnchor == groupsCountLabel.heightAnchor,
            groupsCountLabel.heightAnchor == taskGroupsLabel.heightAnchor
        ])
        
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(taskGroupsLabel)
        }
        
        editButton.snp.makeConstraints { make in
            make.right.equalTo(addButton.snp.left).offset(-16)
            make.centerY.equalTo(taskGroupsLabel)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor == taskGroupsLabel.bottomAnchor + 8,
            tableView.leadingAnchor == view.leadingAnchor,
            tableView.trailingAnchor == view.trailingAnchor,
            tableView.bottomAnchor == view.bottomAnchor
        ])
    }
}

extension GroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseID) as! GroupTableViewCell
        let model = viewModel.groups[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: { [weak self] _,_,_ in
            guard let self else { return }
            self.viewModel.delete(indexPath: indexPath)
        })
        
        deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(UIColor(hexString: "9260F4"), renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension GroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.groups[indexPath.row]
        viewModel.openTask(group: model.group)
    }
}

// MARK: - PreviewProvider
struct GroupsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let coordinator = GroupsScreenCoordinator(
            navigationController: UINavigationController(),
            tabBar: UITabBarController()
        )
        
        let model = GroupsViewControllerViewModel()
        model.coordinator = coordinator
        let vc = GroupsViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
