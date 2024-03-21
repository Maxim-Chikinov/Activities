//
//  TaskViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import UIKit
import SwiftUI
import SnapKit

class TaskViewController: UIViewController {
    
    var viewModel: TaskViewControllerViewModel
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(saveTaskTap), for: .touchUpInside)
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
                descriptionLabel,
                descriptionTextView,
                stateLabel,
                stateSegmentedControl,
                dateLabel,
                datePickerContainer,
                iconStack
            ],
            isScrollabel: true,
            indicatorStyle: .black
        )
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addPadding(32, after: titleTextField)
        stack.addPadding(32, after: descriptionTextView)
        stack.addPadding(32, after: stateSegmentedControl)
        stack.addPadding(32, after: datePickerContainer)
        stack.onScroll = { [weak self] in
            self?.view?.endEditing(true)
        }
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Title"
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
    
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Description"
        return lbl
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        view.font = .systemFont(ofSize: 16)
        view.roundCorners()
        view.addShadow()
        return view
    }()
    
    private lazy var stateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "State"
        return lbl
    }()
    
    private lazy var stateSegmentedControl: CustomSegmentedControl = {
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
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Date"
        return lbl
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var datePickerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor == view.topAnchor,
            datePicker.leadingAnchor == view.leadingAnchor,
            datePicker.bottomAnchor == view.bottomAnchor,
        ])
        return view
    }()
    
    private lazy var iconStack: Stack = {
        let stack = Stack(
            axis: .horizontal,
            distribution: .equalCentering,
            margins: .init(top: 0, left: 50, bottom: 0, right: 50),
            spacing: 16,
            views: [
                colorLabel,
                colorWellView,
                iconLabel,
                iconView
            ]
        )
        return stack
    }()
    
    private lazy var colorLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Color"
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var colorWellView: UIColorWell = {
        let well = UIColorWell()
        well.translatesAutoresizingMaskIntoConstraints = false
        well.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            well.heightAnchor == 40,
            well.widthAnchor == 40
        ])
        
        return well
    }()
    
    private lazy var iconLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Icon"
        return lbl
    }()
    
    private lazy var iconView: TaskIconView = {
        let view = TaskIconView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction { [weak self] in
            guard let self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        NSLayoutConstraint.activate([
            view.heightAnchor == 40,
            view.widthAnchor == 40
        ])
        
        return view
    }()
    
    private lazy var imagePicker = UIImagePickerController()
    
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
        
        viewModel.taskTitle.bind { [weak self] text in
            self?.titleTextField.text = text
        }
        
        viewModel.taskDescription.bind { [weak self] text in
            self?.descriptionTextView.text = text
        }
        
        viewModel.taskState.bind { [weak self] state in
            self?.stateSegmentedControl.selectedSegmentIndex = Int(state.rawValue)
        }
        
        viewModel.taskDate.bind { [weak self] date in
            self?.datePicker.date = date ?? Date()
        }
        
        viewModel.color.bind { [weak self] color in
            self?.colorWellView.selectedColor = color
            self?.iconView.color = color
        }
        
        viewModel.icon.bind { [weak self] icon in
            self?.iconView.icon = icon
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
            descriptionTextView.heightAnchor == 100
        ])
    }
    
    @objc
    private func taskTypeSegmentedControlChanged(_ sender: UISegmentedControl) {}
    
    @objc
    private func saveTaskTap() {
        viewModel.saveAction?(
            titleTextField.text ?? "",
            descriptionTextView.text,
            TaskState(rawValue: Int16(stateSegmentedControl.selectedSegmentIndex)) ?? .all,
            datePicker.date,
            colorWellView.selectedColor,
            iconView.icon
        )
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func colorWellValueChanged() {
        self.viewModel.color.value = colorWellView.selectedColor
        iconView.color = colorWellView.selectedColor
    }
}

extension TaskViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: { () -> Void in
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            self.iconView.icon = image
        })
    }
}

// MARK: - PreviewProvider
struct TaskViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let model = TaskViewControllerViewModel(
            state: .add,
            completion: nil
        )
        let vc = TaskViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
