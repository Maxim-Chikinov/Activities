//
//  TasksViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 17.03.2024.
//

import UIKit
import CoreData

protocol TasksScreenNavigation : AnyObject{
    func addTask(completion: (() -> ())?)
    func goToTask(task: Task, completion: (() -> ())?)
    func goToFilters()
}

class TasksViewControllerViewModel {
    
    enum State {
        case allTasks
        case group(tasks: [Task])
        case select
    }
    
    weak var coordinator: TasksScreenNavigation?
    
    var state: State = .allTasks
    
    var taskTitle = Box("Tasks")
    var taskCount = Box("")
    var tasks = [TaskTableViewCellViewModel]()
    var updateTasksAction: (() -> Void)?
    var deleteTaskAction: ((IndexPath) -> Void)?
    
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    init(state: State) {
        self.state = state
    }
    
    func getData(taskType: TaskState, search: String? = nil) {
        let fetchRequest = Task.fetchRequest()
        
        // Add sort
        let sort = NSSortDescriptor(key: #keyPath(Task.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        // Add predicates
        var predicates: [NSPredicate] = []
        
        // State predicate
        if taskType != .all {
            let statePredicate = NSPredicate(format: "state == %i", taskType.rawValue)
            predicates.append(statePredicate)
        }
        
        // Search predicate
        if let search, !search.isEmpty {
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
            predicates.append(titlePredicate)
        }
        
        // Tasks
        if case .group(let tasks) = state {
            let ids = tasks.map { $0.taskId }
            let taskPredicate = NSPredicate(format: "taskId in %@", ids)
            predicates.append(taskPredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        
        // Fetch
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            self.tasks = tasks.map({ t in
                let task = TaskTableViewCellViewModel()
                task.task = t
                task.title.value = t.title
                task.subtitle.value = t.descripton
                task.date.value = t.date?.formatted()
                task.color.value = t.color as? UIColor ?? .systemBlue
                task.state.value = TaskState(rawValue: t.state)?.title
                task.iconImage.value = UIImage(data: t.iconData ?? Data()) ?? UIImage(named: "taskImg")?.template
                return task
            })
            taskCount.value = "\(self.tasks.count)"
            updateTasksAction?()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addTask() {
        coordinator?.addTask { [weak self] in
            self?.getData(taskType: .all)
        }
    }
    
    func selectTask(task: Task) {
        coordinator?.goToTask(task: task, completion: { [weak self] in
            self?.getData(taskType: .all)
        })
    }
    
    func delete(indexPath: IndexPath) {
        do {
            let task = tasks[indexPath.row].task
            managedObjectContext.delete(task)
            try managedObjectContext.save()
            
            tasks.removeAll(where: { $0.task.taskId == task.taskId })
            taskCount.value = "\(self.tasks.count)"
            
            deleteTaskAction?(indexPath)
        } catch {
            print(error.localizedDescription)
        }
    }
}
