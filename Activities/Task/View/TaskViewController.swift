//
//  TaskViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import UIKit
import SwiftUI

class TaskViewController: UIViewController {
    
    var viewModel: TaskViewControllerViewModel
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addTaskTap), for: .touchUpInside)
        btn.setImage(
            UIImage(systemName: "checkmark.rectangle.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.tintColor = UIColor(hexString: "5F33E1")
        btn.setTitle("SAVE ", for: .normal)
        btn.roundCorners()
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
    }()
    
    private lazy var stack: Stack = {
        let stack = Stack(
            axis: .vertical,
            margins: .init(top: 16, left: 16, bottom: 16, right: 16),
            spacing: 16,
            views: [
                titleLabel,
                titleTextField,
                subtitleLabel,
                subtitleTextView,
                stateLabel,
                taskTypeSegmentedControl,
            ],
            isScrollabel: true,
            indicatorStyle: .black
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addPadding(32, after: titleTextField)
        stack.addPadding(32, after: subtitleTextView)
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Task Title"
        return lbl
    }()
    
    private lazy var titleTextField: InsetTextField = {
        let tf = InsetTextField(insets: .init(top: 0, left: 16, bottom: 0, right: 16))
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Write the name of the task"
        tf.backgroundColor = .white
        tf.roundCorners()
        tf.addShadow()
        return tf
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Subtitle Title"
        return lbl
    }()
    
    private lazy var subtitleTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        view.roundCorners()
        view.addShadow()
        return view
    }()
    
    private lazy var stateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Tast State"
        return lbl
    }()
    
    private lazy var taskTypeSegmentedControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(taskTypeSegmentedControlChanged), for: .primaryActionTriggered)
        
        var types = TaskState.allCases
        types = types.reversed()
        types.forEach { task in
            segmentedControl.insertSegment(withTitle: task.title, at: 0, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.selectedSegmentTintColor = UIColor(hexString: "5F33E2")
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor(hex: "5F33E2"),
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ],
            for: .selected
        )
       
        
        return segmentedControl
    }()
    
    init(viewModel: TaskViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBinding()
        setupSubviews()
        setupConstraints()
        
        view.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getData()
    }
    
    private func setupBinding() {
        viewModel.title.bind { [weak self] text in
            self?.title = text
        }
        
        viewModel.buttonTitle.bind { [weak self] text in
            self?.saveButton.setTitle(text, for: .normal)
        }
    }
    
    private func setupSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        view.addSubviews(stack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor == view.safeAreaLayoutGuide.topAnchor,
            stack.leadingAnchor == view.safeAreaLayoutGuide.leadingAnchor,
            stack.trailingAnchor == view.safeAreaLayoutGuide.trailingAnchor,
            stack.bottomAnchor == view.safeAreaLayoutGuide.bottomAnchor
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor == 40
        ])
        
        NSLayoutConstraint.activate([
            subtitleTextView.heightAnchor == 100
        ])
    }
    
    @objc
    private func taskTypeSegmentedControlChanged(_ sender: UISegmentedControl) {}
    
    @objc
    private func addTaskTap() {
        viewModel.saveAction?()
    }
}

// MARK: - PreviewProvider
struct TaskViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let model = TaskViewControllerViewModel(state: .update(taskId: ""))
        let vc = TaskViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
