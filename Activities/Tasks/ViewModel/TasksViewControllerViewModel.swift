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
    
    weak var coordinator: TasksScreenNavigation?
    
    var taskTitle = Box("Tasks")
    var taskCount = Box("")
    var tasks = Box([TaskTableViewCellViewModel]())
    var addTaskAction: (() -> Void)?
    var taskSelectionAction: ((Task) -> Void)?
    var taskTypeSegmenterAction: ((_ state: TaskState, _ searchText: String) -> Void)?
    
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    init() {
        addTaskAction = { [weak self] in
            self?.coordinator?.addTask { [weak self] in
                self?.getData(taskType: .all)
            }
        }
        
        taskTypeSegmenterAction = { [weak self] state, searchText in
            self?.getData(taskType: state, search: searchText)
        }
        
        taskSelectionAction = { [weak self] task in
            self?.coordinator?.goToTask(task: task, completion: { [weak self] in
                self?.getData(taskType: .all)
            })
        }
    }
    
    func getData(taskType: TaskState, search: String? = nil) {
        let fetchRequest = Task.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Task.date), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let search = search?.lowercased()
        
        var predicates: [NSPredicate] = []
        
        if taskType != .all {
            let statePredicate = NSPredicate(format: "state == %i", taskType.rawValue)
            predicates.append(statePredicate)
        }
        
        if search?.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS %@", search ?? "")
            predicates.append(titlePredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            self.tasks.value = tasks.map({ t in
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
            taskCount.value = "\(self.tasks.value.count)"
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(task: Task, completion: (() -> ())? = nil) {
        do {
            managedObjectContext.delete(task)
            try managedObjectContext.save()
            
            tasks.value.removeAll(where: { $0.task.taskId == task.taskId })
            taskCount.value = "\(self.tasks.value.count)"
            
            completion?()
        } catch {
            print(error.localizedDescription)
        }
    }
}
