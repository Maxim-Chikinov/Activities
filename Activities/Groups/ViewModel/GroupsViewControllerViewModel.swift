//
//  GroupsViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit

protocol GroupsScreenNavigation : AnyObject {
    func goToGroup(group: Group, completion: (() -> ())?)
    func goToAddGroup(completion: (() -> ())?)
}

class GroupsViewControllerViewModel {
    
    weak var coordinator: GroupsScreenNavigation?
    
    var taskGroupsTitle = Box("Tasks Groups")
    var taskGroupsCount = Box("")
    var groups = [GroupTableViewCellViewModel]()
    
    var onGroupsUpdate: (() -> Void)?
    
    let managedObjectContext = CoreDataStack.shared.managedObjectContext
    
    func getData() {
        groups.removeAll()
        
        let fetchRequest = Group.fetchRequest()
        
        do {
            let groups = try managedObjectContext.fetch(fetchRequest)
            groups.forEach { group in
                let cell = GroupTableViewCellViewModel()
                cell.group = group
                cell.title.value = group.title ?? ""
                cell.subtitle.value = group.subtitle ?? ""
                cell.iconImage.value = UIImage(data: group.icon ?? Data())
                cell.color.value = group.color as? UIColor ?? .systemBlue
                self.groups.append(cell)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        taskGroupsCount.value = "\(groups.count)"
        
        onGroupsUpdate?()
    }
    
    func delete(indexPath: IndexPath) {
        do {
            let group = groups[indexPath.row].group
            managedObjectContext.delete(group)
            try managedObjectContext.save()
            
            groups.removeAll(where: { $0.group.id == group.id })
            taskGroupsCount.value = "\(groups.count)"
            
            onGroupsUpdate?()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func openAddTasks() {
        coordinator?.goToAddGroup() { [weak self] in
            self?.getData()
        }
    }
    
    func openTask(group: Group) {
        coordinator?.goToGroup(group: group) {
            
        }
    }
}
