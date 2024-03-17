//
//  TasksViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit

protocol TasksScreenNavigation : AnyObject{
    func goToTask()
    func goToFilters()
}

class TasksViewControllerViewModel {
    
    weak var coordinator: TasksScreenNavigation?
    
    var taskTitle = Box("Tasks")
    var taskCount = Box("")
    var tasks = [TaskTableViewCellViewModel]()
    
    func getData() {
        tasks.removeAll()
        for _ in 0...10 {
            let task = TaskTableViewCellViewModel()
            task.selectButtonAction = { [weak self] in
                self?.coordinator?.goToTask()
            }
            tasks.append(task)
        }
        
        taskCount.value = "\(tasks.count)"
    }
}
