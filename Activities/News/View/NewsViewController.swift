//
//  NewsViewController.swift
//  Activities
//
//  Created by Chikinov Maxim on 11.04.2024.
//

import UIKit
import SwiftUI
import SnapKit
import CoreData

class NewsViewController: UIViewController {
    
    var viewModel: NewsViewModel
    
    private lazy var dataProvider: NewsPostsProvider = {
        let provider = NewsPostsProvider(
            with: CoreDataStack.shared.managedObjectContext,
            fetchedResultsControllerDelegate: self
        )
        return provider
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.indicatorStyle = .white
        tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        tableView.register(cell: NewsCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "News"
        
        setupviews()
        setupBinding()
        
        viewModel.getData()
    }
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(Self.description()): deinit")
    }
    
    private func setupviews() {
        view.addSubviews(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        viewModel.onGroupsUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = dataProvider.fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: NewsCell.self, for: indexPath)
        let currentPost = dataProvider.fetchedResultsController.object(at: indexPath)
        let viewModel = NewsCellViewModel(currentPost: currentPost)
        cell.configure(model: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentPost = dataProvider.fetchedResultsController.object(at: indexPath)
        guard let urlString = currentPost.url, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - Fetched Results Delegate
extension NewsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .none)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        guard let indexPath, let newIndexPath else { return }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .none)
        case .move:
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.insertRows(at: [newIndexPath], with: .none)
        case .update:
            let cell = tableView.dequeueReusableCell(withType: NewsCell.self, for: indexPath)
            let currentPost = dataProvider.fetchedResultsController.object(at: indexPath)
            cell.configure(model: NewsCellViewModel(currentPost: currentPost))
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - PreviewProvider
struct NewsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        let model = NewsViewModel()
        let vc = NewsViewController(viewModel: model)
        let nc = UINavigationController(rootViewController: vc)
        
        return nc
            .toPreview()
            .ignoresSafeArea()
    }
}
