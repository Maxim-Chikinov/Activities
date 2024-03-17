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
    
    weak var coordinator: MainScreenCoordinator?
    
    func getData() {
        taskGroups.removeAll()
        for _ in 0...10 {
            let group = TaskGroupTableViewCellViewModel()
            group.selectButtonAction = { [weak self] in
                self?.coordinator?.goToTasks()
            }
            group.changeButtonAction = { [weak self] in
                self?.coordinator?.goToChangeTask()
            }
            taskGroups.append(group)
        }
        
        taskGroupsCount.value = "\(taskGroups.count)"
    }
}
