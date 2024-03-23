//
//  GroupsViewControllerViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 16.03.2024.
//

import UIKit

protocol GroupsScreenNavigation : AnyObject{
    func goToGroup()
    func goToAddGroup()
}

class GroupsViewControllerViewModel {
    
    weak var coordinator: GroupsScreenNavigation?
    
    var taskGroupsTitle = Box("Tasks Groups")
    var taskGroupsCount = Box("")
    var taskGroups = [TaskGroupTableViewCellViewModel]()
    
    func getData() {
        taskGroups.removeAll()
        taskGroupsCount.value = "\(taskGroups.count)"
    }
    
    func delete(indexPath: IndexPath) {
        
    }
    
    func openAddTasks() {
        coordinator?.goToAddGroup()
    }
    
    func openTask() {
        coordinator?.goToGroup()
    }
}
