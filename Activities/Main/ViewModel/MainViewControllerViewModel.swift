//
//  MainViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit

class MainViewControllerViewModel {
    var taskGroupsTitle = Box("Tasks Groups")
    var taskGroupsCount = Box("")
    var taskGroups = [TaskGroupTableViewCellViewModel]()
    
    weak var context: UIViewController?
    
    init(context: UIViewController) {
        self.context = context
    }
    
    func getData() {
        taskGroups.removeAll()
        for _ in 0...10 {
            let group = TaskGroupTableViewCellViewModel()
            group.selectButtonAction = { [weak self] in
                let nc = self?.context?.navigationController
                let tasksVC = UIViewController()
                tasksVC.view.backgroundColor = .white
                nc?.pushViewController(tasksVC, animated: true)
            }
            group.changeButtonAction = { [weak self] in
                if let vc = self?.context {
                    let changeVC = UIViewController()
                    changeVC.view.backgroundColor = .white
                    vc.present(changeVC, animated: true)
                }
            }
            taskGroups.append(group)
        }
        
        taskGroupsCount.value = "\(taskGroups.count)"
    }
}
