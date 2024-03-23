//
//  GroupViewModel.swift
//  Activities
//
//  Created by Chikinov Maxim on 22.03.2024.
//

import UIKit

class GroupViewModel {
    
    enum State {
        case add
        case edite
    }
    
    weak var coordinator: GroupsScreenNavigation?
    
    var state: State
    
    var navigationTitle = Box("")
    var title = Box("")
    var subtitle = Box("")
    
    var iconImage = Box(UIImage(named: "taskImg")?.withRenderingMode(.alwaysTemplate))
    var color = Box(UIColor.systemBlue)
    
    var tasks = Box([TaskTableViewCellViewModel]())
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .add:
            navigationTitle.value = "Add group"
        case .edite:
            navigationTitle.value = "Group"
        }
    }
    
    func save() {
        
    }
    
    func editTasks() {
        
    }
}
