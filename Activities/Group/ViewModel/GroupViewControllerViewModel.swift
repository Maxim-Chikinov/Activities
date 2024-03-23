//
//  GroupViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 22.03.2024.
//

import UIKit

protocol GroupScreenNavigation : AnyObject {
    func goToAddTasks()
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
    var completion: (() -> ())?
    
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
        }
    }
    
    func save(
        title: String?,
        description: String?,
        icon: UIImage?,
        color: UIColor?,
        newTasks: [Task],
        completion: (() -> ())?
    ) {
        let groupEntity = Group(context: managedObjectContext)
        
        groupEntity.setValue(title, forKey: #keyPath(Group.title))
        groupEntity.setValue(description, forKey: #keyPath(Group.subtitle))
        groupEntity.setValue(description, forKey: #keyPath(Group.subtitle))
        groupEntity.setValue(icon?.pngData(), forKey: #keyPath(Group.icon))
        groupEntity.setValue(color, forKey: #keyPath(Group.color))
        
        if let tasks = groupEntity.tasks?.mutableCopy() as? NSMutableSet {
            tasks.addObjects(from: newTasks)
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
        coordinator?.goToAddTasks()
    }
}
