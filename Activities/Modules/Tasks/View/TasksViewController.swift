//
//  TasksViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit
import SwiftUI

class TasksViewController: CustomViewController {
    
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
    
    private lazy var addTaskButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addTaskTap), for: .touchUpInside)
        btn.setImage(
            UIImage(systemName: "plus.rectangle.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.tintColor = UIColor(hexString: "5F33E1")
        btn.setTitle("Add task ", for: .normal)
        btn.roundCorners()
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
    }()
    
    private lazy var taskTypeSegmentedControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(taskTypeSegmentedControlChanged), for: .primaryActionTriggered)
        segmentedControl.selectedSegmentTintColor = UIColor(hexString: "5F33E2")
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor(hex: "5F33E2"),
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold)
            ],
            for: .selected
        )
        return segmentedControl
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.separatorColor = .clear
        tableView.register(cellType: TaskTableViewCell.self)
        tableView.tableHeaderView = searchBar
        return tableView
    }()
    
    init(viewModel: TasksViewControllerViewModel) {
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
        title = "Tasks"
        
        setupBinding()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getData(taskType: getSegmentType())
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
        
        viewModel.tasksStateFilters.bind { [weak self] filters in
            guard let self else { return }
            
            let selectedSegmentIndex = self.taskTypeSegmentedControl.selectedSegmentIndex
            
            // Set segments
            self.taskTypeSegmentedControl.removeAllSegments()
            let filters = filters.reversed()
            filters.forEach { [weak self] filter in
                guard let self else { return }
                self.taskTypeSegmentedControl.insertSegment(withTitle: filter, at: 0, animated: false)
            }
            self.taskTypeSegmentedControl.insertSegment(withTitle: TaskState.all.title, at: 0, animated: false)
            self.taskTypeSegmentedControl.setWidth(50, forSegmentAt: 0)
            
            // Set selected segment
            if selectedSegmentIndex == -1 {
                self.taskTypeSegmentedControl.selectedSegmentIndex = 0
            } else {
                self.taskTypeSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
            }
        }
        
        viewModel.updateTasksAction = { [weak self] in
            self?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
        
        viewModel.deleteTaskAction = { [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(
            taskGroupsLabel, taskGroupsCountLabel, addTaskButton,
            taskTypeSegmentedControl,
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
            addTaskButton.centerYAnchor == taskGroupsLabel.centerYAnchor,
            addTaskButton.trailingAnchor == view.trailingAnchor - 16,
            addTaskButton.heightAnchor == 48
        ])
        
        NSLayoutConstraint.activate([
            taskTypeSegmentedControl.topAnchor == taskGroupsCountLabel.bottomAnchor + 16,
            taskTypeSegmentedControl.leadingAnchor == view.leadingAnchor + 16,
            taskTypeSegmentedControl.trailingAnchor == view.trailingAnchor - 16
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor == taskTypeSegmentedControl.bottomAnchor + 8,
            tableView.leadingAnchor == view.leadingAnchor,
            tableView.trailingAnchor == view.trailingAnchor,
            tableView.bottomAnchor == view.bottomAnchor
        ])
    }
    
    private func getSegmentType() -> TaskState {
        var selectedIndex = Int16(taskTypeSegmentedControl.selectedSegmentIndex)
        switch selectedIndex {
        case 0:
            selectedIndex = 4
        default:
            selectedIndex -= 1
        }
        
        return TaskState(rawValue: selectedIndex) ?? .all
    }
    
    @objc
    private func taskTypeSegmentedControlChanged(_ sender: UISegmentedControl) {
        viewModel.getData(taskType: getSegmentType(), search: searchBar.text)
    }
    
    @objc
    private func addTaskTap() {
        viewModel.addTask()
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

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.tasks[indexPath.row]
        viewModel.selectTask(task: model.task)
        view.endEditing(true)
    }
}

extension TasksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getData(taskType: getSegmentType(), search: searchBar.text)
    }
}

// MARK: - PreviewProvider
struct TasksViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let coordinator = TasksScreenCoordinator(
            navigationController: UINavigationController(),
            tabBar: UITabBarController()
        )
        
        let model = TasksViewControllerViewModel(state: .allTasks)
        model.coordinator = coordinator
        let vc = TasksViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
