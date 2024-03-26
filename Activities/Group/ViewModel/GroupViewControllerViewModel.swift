//
//  GroupViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 22.03.2024.
//

import UIKit

protocol GroupScreenNavigation : AnyObject {
    func goToAddTasks(onAddTaskCompletion: ((Task) -> Void)?)
}

class GroupViewControllerViewModel {
    
    enum State {
        case add
        case edite(group: Group)
    }
    
    weak var coordinator: GroupScreenNavigation?
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    var state: State
    
    var navigationTitle = Box("")
    var title = Box("")
    var subtitle = Box("")
    var iconImage = Box(UIImage(named: "taskImg")?.withRenderingMode(.alwaysTemplate))
    var color = Box(UIColor.systemBlue)
    var tasks = Box([TaskTableViewCellViewModel]())
    var onAddTask: (() -> ())?
    var completion: (() -> ())?
    
    var newTasks: [Task] = []
    var deletedTasks: [Task] = []
    
    init(state: State, completion: (() -> ())?) {
        self.state = state
        self.completion = completion
        
        switch state {
        case .add:
            navigationTitle.value = "Add group"
        case .edite(let group):
            navigationTitle.value = "Group"
            title.value = group.title ?? ""
            subtitle.value = group.subtitle ?? ""
            
            if let tasks = group.tasks {
                self.tasks.value = tasks.compactMap({ element in
                    guard let task = element as? Task else { return nil }
                    return TaskTableViewCellViewModel(task: task)
                })
            }
        }
    }
    
    func save(
        title: String?,
        description: String?,
        icon: UIImage?,
        color: UIColor?,
        completion: (() -> ())?
    ) {
        let groupEntity: Group
        
        switch state {
        case .add:
            groupEntity = Group(context: managedObjectContext)
        case .edite(let group):
            groupEntity = group
        }
        
        groupEntity.setValue(title, forKey: #keyPath(Group.title))
        groupEntity.setValue(description, forKey: #keyPath(Group.subtitle))
        groupEntity.setValue(description, forKey: #keyPath(Group.subtitle))
        groupEntity.setValue(icon?.pngData(), forKey: #keyPath(Group.icon))
        groupEntity.setValue(color, forKey: #keyPath(Group.color))
        
        if let tasks = groupEntity.tasks?.mutableCopy() as? NSMutableSet {
            tasks.addObjects(from: newTasks)
            deletedTasks.forEach { task in
                tasks.remove(task)
            }
            groupEntity.tasks = tasks
        }
        
        do {
            try self.managedObjectContext.save()
            completion?()
            self.completion?()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addTasks() {
        coordinator?.goToAddTasks(onAddTaskCompletion: { [weak self] task in
            guard let self else { return }
            
            self.newTasks.append(task)
            self.tasks.value.append(TaskTableViewCellViewModel(task: task))
            self.onAddTask?()
        })
    }
    
    func delete(indexPath: IndexPath) {
        let task = tasks.value[indexPath.row].task
        deletedTasks.append(task)
        tasks.value.remove(at: indexPath.row)
        newTasks.removeAll(where: { $0.taskId == task.taskId })
    }
}
