//
//  TaskViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 18.03.2024.
//

import UIKit

protocol TaskScreenNavigation : AnyObject{
    
}

class TaskViewControllerViewModel {
    
    enum State {
        case add
        case update(taskId: String)
    }
    
    weak var coordinator: TaskScreenNavigation?
    
    var title = Box("Tasks")
    var buttonTitle = Box("Save")
    var saveAction: (() -> Void)?
    var taskTitle = Box("")
    var taskDescription = Box("")
    var taskState = Box(TaskState.all)
    var taskDate = Box(Date())
    
    init(state: State) {
        switch state {
        case .add:
            title.value = "Add new task"
            buttonTitle.value = "SAVE"
        case .update(taskId: let taskId):
            _ = taskId
            title.value = "Update task"
            buttonTitle.value = "UPDATE"
        }
        
        saveAction = { [weak self] in
            _ = self
        }
    }
    
    func getData() {
        
    }
}
