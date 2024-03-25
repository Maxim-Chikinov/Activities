//
//  GroupViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 22.03.2024.
//

import UIKit
import SwiftUI
import SnapKit

class GroupViewController: UIViewController {
    
    var viewModel: GroupViewControllerViewModel
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addAction { [weak self] in
            guard let self else { return }
            self.viewModel.save(
                title: titleTextView.text,
                description: descriptionTextView.text,
                icon: iconView.icon,
                color: colorWellView.selectedColor
            ) { [weak self] in
                guard let self else { return }
                switch self.viewModel.state {
                case .add:
                    self.dismiss(animated: true)
                case .edite:
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        btn.setImage(
            UIImage(systemName: "checkmark.rectangle.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.tintColor = UIColor(hexString: "5F33E1")
        btn.setTitle("Save ", for: .normal)
        btn.roundCorners()
        btn.semanticContentAttribute = .forceRightToLeft
        btn.setContentHuggingPriority(.required, for: .horizontal)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Title"
        return lbl
    }()
    
    private lazy var titleTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = .init(top: 16, left: 16, bottom: 0, right: 16)
        view.textContainer.maximumNumberOfLines = 1
        view.font = .systemFont(ofSize: 16)
        view.roundCorners()
        view.addShadow()
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Description"
        return lbl
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = .init(top: 16, left: 16, bottom: 0, right: 16)
        view.textContainer.maximumNumberOfLines = 1
        view.font = .systemFont(ofSize: 16)
        view.roundCorners()
        view.addShadow()
        return view
    }()
    
    private lazy var iconStack: Stack = {
        let stack = Stack(
            axis: .horizontal,
            distribution: .equalCentering,
            margins: .init(top: 0, left: 0, bottom: 0, right: 0),
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
        well.addTarget(self, action: #selector(colorWellValueChanged), for: .valueChanged)
        return well
    }()
    
    private lazy var iconLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Icon"
        return lbl
    }()
    
    private lazy var iconView: TaskIconView = {
        let view = TaskIconView()
        view.addAction { [weak self] in
            guard let self else { return }
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        return view
    }()
    
    private lazy var tasksLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Tasks"
        lbl.textAlignment = .left
        return lbl
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addAction { [weak self] in
            self?.viewModel.addTasks()
        }
        btn.setImage(
            UIImage(systemName: "plus.rectangle.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        btn.tintColor = UIColor(hexString: "5F33E1")
        btn.setTitle("Add ", for: .normal)
        btn.roundCorners()
        btn.semanticContentAttribute = .forceRightToLeft
        btn.setContentHuggingPriority(.required, for: .horizontal)
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.separatorColor = .clear
        tableView.register(cellType: TaskTableViewCell.self)
        return tableView
    }()
    
    private lazy var imagePicker = UIImagePickerController()
    
    init(viewModel: GroupViewControllerViewModel) {
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
        title = "Group"
        
        setupBinding()
        setupSubviews()
        setupConstraints()
        
        view.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func setupBinding() {
        viewModel.navigationTitle.bind { [weak self] text in
            self?.title = text
        }
        
        viewModel.title.bind { [weak self] text in
            self?.titleTextView.text = text
        }
        
        viewModel.subtitle.bind { [weak self] text in
            self?.descriptionTextView.text = text
        }
        
        viewModel.iconImage.bind { [weak self] image in
            self?.iconView.icon = image
        }
        
        viewModel.color.bind { [weak self] color in
            self?.iconView.color = color
        }
        
        viewModel.tasks.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.onAddTask = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(
            titleLabel,
            titleTextView,
            descriptionLabel,
            descriptionTextView,
            iconStack,
            tasksLabel,
            addButton,
            tableView
        )
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.height.equalTo(48)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(16)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.height.equalTo(48)
        }
        
        iconStack.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.height.equalTo(40)
        }
        
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        colorWellView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        tasksLabel.snp.makeConstraints { make in
            make.top.equalTo(iconStack.snp.bottom).offset(16)
            make.left.equalTo(view).offset(16)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(iconStack.snp.bottom).offset(16)
            make.left.equalTo(tasksLabel.snp.right).offset(16)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(tasksLabel.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tasksLabel.snp.bottom).offset(8)
            make.left.equalTo(view).offset(0)
            make.right.equalTo(view).offset(0)
            make.bottom.equalTo(view).offset(0)
        }
    }
    
    @objc
    private func colorWellValueChanged() {
        self.viewModel.color.value = colorWellView.selectedColor ?? .systemBlue
        iconView.color = colorWellView.selectedColor
    }
    
    @objc
    private func editButtonTap() {
        
    }
}

extension GroupViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: { () -> Void in
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            self.iconView.icon = image
        })
    }
}

extension GroupViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseID) as! TaskTableViewCell
        let model = viewModel.tasks.value[indexPath.row]
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
        deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(
            UIColor(hexString: "9260F4"), 
            renderingMode: .alwaysOriginal
        )
        deleteAction.backgroundColor = .white
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - PreviewProvider
struct GroupViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let model = GroupViewControllerViewModel(state: .add, completion: nil)
        let vc = GroupViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
