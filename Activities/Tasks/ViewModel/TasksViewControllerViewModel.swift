//
//  TasksViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit

protocol TasksScreenNavigation : AnyObject{
    func addTask()
    func goToTask()
    func goToFilters()
}

class TasksViewControllerViewModel {
    
    weak var coordinator: TasksScreenNavigation?
    
    var taskTitle = Box("Tasks")
    var taskCount = Box("")
    var tasks = Box([TaskTableViewCellViewModel]())
    var addTaskAction: (() -> Void)?
    var taskTypeSegmenterAction: ((Int) -> Void)?
    
    init() {
        addTaskAction = { [weak self] in
            self?.coordinator?.addTask()
        }
        
        taskTypeSegmenterAction = { [weak self] index in
            let type = TaskState(rawValue: index) ?? .all
            self?.getData(taskType: type)
        }
    }
    
    func getData(taskType: TaskState) {
        var tasks = [TaskTableViewCellViewModel]()
        for _ in 0...10 / (taskType.rawValue + 1) {
            let task = TaskTableViewCellViewModel()
            task.selectButtonAction = { [weak self] in
                self?.coordinator?.goToTask()
            }
            tasks.append(task)
        }
        
        self.tasks.value = tasks
        
        taskCount.value = "\(tasks.count)"
    }
}
