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
        case select(completion: ((_ task: Task) -> ())?)
    }
    
    weak var coordinator: TasksScreenNavigation?
    
    var state: State = .allTasks
    
    var taskTitle = Box("Tasks")
    var taskCount = Box("")
    var tasksStateFilters = Box([String]())
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
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        
        // Fetch
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            self.tasks = tasks.map({ TaskTableViewCellViewModel(task: $0) })
            taskCount.value = "\(self.tasks.count)"
            updateTasksAction?()
        } catch {
            print(error.localizedDescription)
        }
        
        // Set segments
        var toDoCounter = 0
        var progressCounter = 0
        var completeCounter = 0
        
        // Todo counts
        do {
            let tasksCountsFetchReques = Task.fetchRequest()
            tasksCountsFetchReques.predicate = NSPredicate(format: "%K == %i", #keyPath(Task.state), TaskState.todo.rawValue)
            
            do {
                let results = try managedObjectContext.fetch(tasksCountsFetchReques)
                toDoCounter = results.count
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Progress counts
        do {
            let tasksCountsFetchReques = Task.fetchRequest()
            tasksCountsFetchReques.predicate = NSPredicate(format: "%K == %i", #keyPath(Task.state), TaskState.inProgress.rawValue)
            
            do {
                let results = try managedObjectContext.fetch(tasksCountsFetchReques)
                progressCounter = results.count
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Complete counts
        do {
            let tasksCountsFetchReques = Task.fetchRequest()
            tasksCountsFetchReques.predicate = NSPredicate(format: "%K == %i", #keyPath(Task.state), TaskState.complete.rawValue)
            
            do {
                let results = try managedObjectContext.fetch(tasksCountsFetchReques)
                completeCounter = results.count
            } catch {
                print(error.localizedDescription)
            }
        }
        
        tasksStateFilters.value = ["To-do(\(toDoCounter))", "In progress(\(progressCounter))", "Complete(\(completeCounter))"]
    }
    
    func addTask() {
        coordinator?.addTask { [weak self] in
            self?.getData(taskType: .all)
        }
    }
    
    func selectTask(task: Task) {
        switch state {
        case .allTasks:
            coordinator?.goToTask(task: task, completion: { [weak self] in
                self?.getData(taskType: .all)
            })
        case .select(let completion):
            completion?(task)
        }
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
