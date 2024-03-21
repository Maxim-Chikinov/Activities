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
        case update(task: Task)
    }
    
    weak var coordinator: TaskScreenNavigation?
    
    var title = Box(String?(""))
    var buttonTitle = Box("")
    var saveAction: ((_ title: String, _ description: String, _ state: TaskState, _ date: Date, _ color: UIColor?, _ icon: UIImage?) -> Void)?
    var taskTitle = Box(String?(""))
    var taskDescription = Box(String?(""))
    var taskState = Box(TaskState.all)
    var taskDate = Box(Date?(Date()))
    var color = Box(UIColor?(.systemBlue))
    var icon = Box(UIImage(named: "taskImg"))
    
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    init(state: State, completion: (() -> ())?) {
        switch state {
        case .add:
            title.value = "Add new task"
            buttonTitle.value = "SAVE"
        case .update(let task):
            title.value = "Update task"
            buttonTitle.value = "UPDATE"
            taskTitle.value = task.title
            taskDescription.value = task.descripton
            taskDate.value = task.date
            taskState.value = TaskState(rawValue: task.state) ?? .all
            color.value = task.color as? UIColor
            icon.value = UIImage(data: task.iconData ?? Data())
        }
        
        saveAction = { [weak self] title, description, taskState, date, color, icon in
            guard let self else { return }
            
            let taskEntity: Task
            
            switch state {
            case .add:
                taskEntity = Task(context: self.managedObjectContext)
            case .update(let task):
                taskEntity = task
            }
            
            taskEntity.setValue(UUID(), forKey: #keyPath(Task.taskId))
            taskEntity.setValue(title, forKey: #keyPath(Task.title))
            taskEntity.setValue(description, forKey: #keyPath(Task.descripton))
            taskEntity.setValue(date, forKey: #keyPath(Task.date))
            taskEntity.setValue(color, forKey: #keyPath(Task.color))
            taskEntity.setValue(taskState.rawValue, forKey: #keyPath(Task.state))
            taskEntity.setValue(icon?.pngData(), forKey: #keyPath(Task.iconData))
            
            do {
                try self.managedObjectContext.save()
                completion?()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getData() {
        
    }
}
